//
//  VerifyCodeNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol VerifyCodeNavigatorProtocol {
    func popToBack()
    func navigateToLookingFor()
}


class VerifyCodeNavigator: VerifyCodeNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = true
        navigationController.title = "Login"
        self.navigationController = navigationController
    }
    
    func navigateToLookingFor() {
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "lookingForVC") as! LookingForViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = LookingForNavigator(navigationController: nc)
            let viewModel = LookingForViewModel(service: service,type: .Looking, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func popToBack() {
        navigationController?.popViewController(animated: true)
    }
}
