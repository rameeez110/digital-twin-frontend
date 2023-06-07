//
//  VerifyCodeViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
protocol VerifyCodeViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
}

// Protocol for view model will use it for wiring
protocol VerifyCodeViewModelProtocol {

    var delegate: VerifyCodeViewModelDelegate? { get set }
    
    func didTapSubmit(code: String)
    func didTapBack()
}

final class VerifyCodeViewModel: VerifyCodeViewModelProtocol {
    
    weak var delegate: VerifyCodeViewModelDelegate?
    private let navigator: VerifyCodeNavigator
    private let userService: UserServiceProtocol

    init(service: UserServiceProtocol,navigator: VerifyCodeNavigator, delegate: VerifyCodeViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
    }

    func didTapSubmit(code: String) {
        let (status,string) = self.validateFields(code: code)
        if status {
           self.navigator.navigateToLookingFor()
        } else {
            self.delegate?.alert(with: "Alert!", message: string)
        }
    }
    
    func didTapBack() {
        self.navigator.popToBack()
    }
    
    func validateFields(code: String) -> (Bool,String) {
        if code .isEmpty {
            return (false,"Email can not be empty.")
        } else {
            return (true,"")
        }
    }
}

extension VerifyCodeViewModel: UserServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
}
