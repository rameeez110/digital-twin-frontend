//
//  LookingForNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol LookingForNavigatorProtocol {
    func navigateToHome()
    func navigateToFilters()
    func navigateToProfile()
}


class LookingForNavigator: LookingForNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = true
        self.navigationController = navigationController
    }
    
    func popToLoginVC(){
        self.navigationController?.popViewController(animated: true)
    }
    func navigateToFilters() {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .tabbar)
        let vc = storyboard.instantiateViewController(withIdentifier: "filterVC") as! FilterViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = FilterRemoteDataStore()
            let repository = FilterRepository.init(filterDataSource: remoteDataSource)
            let service = FilterService.init(filterRepository: repository)
            let navigator = FilterNavigator(navigationController: nc)
            let viewModel = FilterViewModel(service: service, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            vc.isComingFromRegistration = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func navigateToHome() {
        if let mySceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            mySceneDelegate.navigator.makeHomeRoot(into: mySceneDelegate.window ?? UIWindow())
        }
    }
    func navigateToProfile() {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "lookingForVC") as! LookingForViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = LookingForNavigator(navigationController: nc)
            let viewModel = LookingForViewModel(service: service,type: .Profile, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
