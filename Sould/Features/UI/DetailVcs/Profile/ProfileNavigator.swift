//
//  ProfileNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 16/08/2022.
//

import UIKit

protocol ProfileNavigatorProtocol {
    func goBack()
}


class ProfileNavigator: ProfileNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func goToInvites(ref: ProfileViewModel) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "inviteVC") as! InvitesViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = AdminRemoteDataStore()
            let repository = AdminRepository.init(remoteUserDataSource: remoteDataSource)
            let service = AdminService.init(adminRepository: repository)
            let navigator = ProfileNavigator(navigationController: nc)
            let viewModel = InvitesViewModel.init(service: service, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            vc.delegate = ref
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func goToUserListing() {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "userListingVC") as! UserListingViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = UserRemoteDataStore()
            let repository = UserRepository(remoteUserDataSource: remoteDataSource)
            let service = UserService(userRepository: repository)
            let navigator = UserListingNavigator(navigationController: nc)
            let viewModel = UserListingViewModel(service: service, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
