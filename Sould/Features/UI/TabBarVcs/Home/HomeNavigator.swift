//
//  HomeNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol HomeNavigatorProtocol {
    func navigateToHomeDetail(data: Property)
    func navigateToHomeGallery(data: Property)
    func navigateToProfile(invites: [Invite])
}

class HomeNavigator: HomeNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }
    func navigateToHomeGallery(data: Property){
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeGalleryVC") as! HomeGalleryViewController
        // View Model create & setup
        vc.data = data
        if let nc = self.navigationController {
//            nc.pushViewController(vc, animated: true)
            nc.pushViewController(vc, animated: false)
        }
    }
    func navigateToHomeDetail(data: Property){
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeDetailVC") as! HomeDetailViewController
        // View Model create & setup
        vc.data = data
//        if let nc = self.navigationController {
//            nc.pushViewController(vc, animated: true)
//        }
        if let nc = self.navigationController {
            let remoteDataSource = AdminRemoteDataStore()
            let repository = AdminRepository.init(remoteUserDataSource: remoteDataSource)
            let service = AdminService.init(adminRepository: repository)
            let navigator = MessageNavigator(navigationController: nc)
            let viewModel = HomeDetailViewModel.init(service: service, navigator: navigator, property: data)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
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
