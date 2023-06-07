//
//  LoginViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

protocol LoginViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func hideLoader()
}

// Protocol for view model will use it for wiring
protocol LoginViewModelProtocol {

    var delegate: LoginViewModelDelegate? { get set }
    var user: User { get set }
    
    func didTapRegister()
    func didTapLogin(email: String,password: String)
    func didTapForgetPassword()
    func googleLogin(token: String)
    func appleLogin(token: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    private let navigator: LoginNavigatorProtocol
    private let userService: UserServiceProtocol
    var user: User

    init(user: User,service: UserServiceProtocol,navigator: LoginNavigatorProtocol, delegate: LoginViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
        self.user = user
    }

    func didTapLogin(email: String,password: String) {
        let (status,string) = self.validateFields(email: email,password: password)
        if status {
            self.delegate?.hideInfoLabel()
            self.user.email = email
            self.user.password = password
            self.userService.loginUser(user: user)
        } else {
            self.delegate?.hideLoader()
            self.delegate?.alert(with: "Alert!", message: string)
        }
    }
    
    func googleLogin(token: String) {
        self.userService.googleLogin(token: token)
    }
    
    func appleLogin(token: String) {
        self.userService.appleLogin(token: token)
    }
    
    func didTapForgetPassword() {
        self.navigator.navigateToForgetPassword()
    }

    func didTapRegister() {
        self.navigator.navigateToRegister()
    }
    
    func validateFields(email: String,password: String) -> (Bool,String) {
        if email.isEmpty && password.isEmpty{
            return (false,"Email and password can not be empty.")
        }else{
            if email.isEmpty{
                return (false,"Email can not be empty.")
            } else if password.isEmpty {
                return (false,"Password can not be empty.")
            } else if !CommonClass.sharedInstance.isValidEmail(email) {
                return (false,"Invalid email address")
            } else {
                return (true,"")
            }
        }
    }
    
}

extension LoginViewModel: UserServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.hideLoader()
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didLoggedIn(user: User) {
        self.delegate?.hideLoader()
        if user.isFirstLogin {
            self.navigator.navigateToLookingFor()
        } else {
            self.navigator.navigateToHome()
        }
    }
}
