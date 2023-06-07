//
//  FilterNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol FilterNavigatorProtocol {
    func navigateToHome()
    func navigateToProfile(invites: [Invite])
}


class FilterNavigator: FilterNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }
    func navigateToHome() {
        if let mySceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            mySceneDelegate.navigator.makeHomeRoot(into: mySceneDelegate.window ?? UIWindow())
        }
    }
    func navigateToProfile(invites: [Invite]) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = ProfileNavigator(navigationController: nc)
            let viewModel = ProfileViewModel(service: service, navigator: navigator, invites: invites, mode: false)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
