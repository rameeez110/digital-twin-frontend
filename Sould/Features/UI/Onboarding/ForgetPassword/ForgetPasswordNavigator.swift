//
//  ForgetPasswordNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

protocol ForgetPasswordNavigatorProtocol {
    func popToLoginVC()
    func didTapSubmit()
}


class ForgetPasswordNavigator: ForgetPasswordNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = true
        self.navigationController = navigationController
    }
    
    func popToLoginVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapSubmit() {
        
    }
}
