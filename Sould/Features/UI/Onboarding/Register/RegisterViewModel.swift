//
//  RegisterViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

protocol RegisterViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func showVerifyPopup()
}

// Protocol for view model will use it for wiring
protocol RegisterViewModelProtocol {

    var delegate: RegisterViewModelDelegate? { get set }
    
    func didTapSignup(fName: String,lName: String,email: String,password: String, confirmPassword: String)
    func didTapGoBack()
    func goToLookingFor()
}

final class RegisterViewModel: RegisterViewModelProtocol {
    weak var delegate: RegisterViewModelDelegate?
    private let navigator: RegisterNavigatorProtocol
    private let userService: UserServiceProtocol
    var user: User

    init(user: User,service: UserServiceProtocol,navigator: RegisterNavigatorProtocol, delegate: RegisterViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
        self.user = user
    }

    func didTapSignup(fName: String,lName: String,email: String,password: String, confirmPassword: String) {
        let (status,string) = self.validateFields(fName: fName,lName: lName,email: email,password: password, confirmPassword: confirmPassword)
        if status {
            self.delegate?.hideInfoLabel()
            self.user.email = email
            self.user.password = password
            self.user.firstName = fName
            self.user.lastName = lName
            self.userService.registerUser(user: user)
        } else {
            self.delegate?.alert(with: "Alert!", message: string)
        }
    }
    
    func didTapGoBack(){
        self.navigator.navigateToLogin()
    }
    func goToLookingFor() {
        self.navigator.navigateToLookingFor()
    }
    
    func validateFields(fName: String,lName: String,email: String,password: String, confirmPassword: String) -> (Bool,String) {
        if email.isEmpty && password.isEmpty && confirmPassword.isEmpty{
            return (false,"Fields can not be empty.")
        }else{
            if email.isEmpty {
                return (false,"Email can not be empty.")
            } else if !CommonClass.sharedInstance.isValidEmail(email) {
                return (false,"Invalid email address")
            } else if fName.isEmpty{
                return (false,"Firstname can not be empty.")
            } else if lName.isEmpty{
                return (false,"Last name can not be empty.")
            } else if password.isEmpty{
                return (false,"Password can not be empty.")
            } else if confirmPassword.isEmpty{
                return (false, "Confirm Password can not be empty")
            }
            else{
                return (true,"")
            }
        }
    }
    
}

extension RegisterViewModel: UserServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didRegistered(user: User) {
        self.delegate?.showVerifyPopup()
    }
}
