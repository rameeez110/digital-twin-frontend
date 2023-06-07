//
//  LoginNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

protocol LoginNavigatorProtocol {
    func navigateToRegister()
    func navigateToForgetPassword()
    func navigateToHome()
    func navigateToLookingFor()
}


class LoginNavigator: LoginNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = true
        navigationController.title = "Login"
        self.navigationController = navigationController
    }
    func navigateToRegister() {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .main)
        let vc: RegisterViewController = storyboard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController//storyboard.instantiateViewController()
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = RegisterNavigator(navigationController: nc)
            let viewModel = RegisterViewModel(user: User(), service: service, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToForgetPassword() {
        let storyboard = UIStoryboard(storyboard: .main)
        let vc: ForgetPasswordViewController = storyboard.instantiateViewController(withIdentifier: "forgetPasswordVC") as! ForgetPasswordViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = ForgetPasswordNavigator(navigationController: nc)
            let viewModel = ForgetPasswordViewModel(service: service, navigator: navigator)
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
    
    func navigateToHome() {
        if let mySceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            mySceneDelegate.navigator.makeHomeRoot(into: mySceneDelegate.window ?? UIWindow())
        }
    }
}
