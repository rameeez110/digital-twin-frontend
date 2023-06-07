//
//  UserListingNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 15/02/2023.
//

import UIKit

protocol UserListingNavigatorProtocol {
    func goBack()
}


class UserListingNavigator: UserListingNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func navigateToProfile(user: User) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
            let service = UserService.init(userRepository: repository)
            let navigator = ProfileNavigator(navigationController: nc)
            let viewModel = ProfileViewModel(service: service, navigator: navigator, invites: [Invite](),mode: true)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            viewModel.viewUser = user
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
