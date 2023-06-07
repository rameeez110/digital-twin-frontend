//
//  RegisterNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

protocol RegisterNavigatorProtocol {
    func navigateToLogin()
    func navigateToVerify(user: User)
    func navigateToLookingFor()
}


class RegisterNavigator: RegisterNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = true
        navigationController.title = "Register"
        self.navigationController = navigationController
    }
   
    func navigateToLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    func navigateToVerify(user: User) {
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "verifyCodeVC") as! VerifyCodeViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = VerifyCodeNavigator(navigationController: nc)
            let viewModel = VerifyCodeViewModel(service: service, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
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
}
