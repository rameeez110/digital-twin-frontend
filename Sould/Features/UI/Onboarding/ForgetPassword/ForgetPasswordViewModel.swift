//
//  ForgetPasswordViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

protocol ForgetPasswordViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func showAlert(response: String)
}

// Protocol for view model will use it for wiring
protocol ForgetPasswordViewModelProtocol {

    var delegate: ForgetPasswordViewModelDelegate? { get set }
    
    func didTapSubmit(email: String)
    func didTapBack()
}

final class ForgetPasswordViewModel: ForgetPasswordViewModelProtocol {
    
    weak var delegate: ForgetPasswordViewModelDelegate?
    private let navigator: ForgetPasswordNavigator
    private let userService: UserServiceProtocol

    init(service: UserServiceProtocol,navigator: ForgetPasswordNavigator, delegate: ForgetPasswordViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
    }

    func didTapSubmit(email: String) {
        let (status,string) = self.validateFields(email: email)
        if status {
//           self.navigator.didTapSubmit()
            self.delegate?.hideInfoLabel()
            self.userService.forgetPassword(email: email)
        } else {
            self.delegate?.alert(with: "Alert!", message: string)
        }
    }
    
    func didTapBack() {
        self.navigator.popToLoginVC()
    }
    
    func validateFields(email: String) -> (Bool,String) {
        if email.isEmpty {
            return (false,"Email can not be empty.")
        } else if !CommonClass.sharedInstance.isValidEmail(email) {
            return (false,"Invalid email address")
        } else {
            return (true,"")
        }
    }
}

extension ForgetPasswordViewModel: UserServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didPasswordReset(response: String) {
        self.delegate?.showAlert(response: response)
    }
}
