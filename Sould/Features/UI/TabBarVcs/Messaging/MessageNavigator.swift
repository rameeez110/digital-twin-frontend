//
//  MessageNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol MessageNavigatorProtocol {
    func navigateToHome()
}


class MessageNavigator: MessageNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }
    func navigateToHome() {
        
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
            let viewModel = HomeDetailViewModel.init(service: service, navigator: self, property: data)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func navigateToClients() {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .detail)
        let vc = storyboard.instantiateViewController(withIdentifier: "clientsVc") as! ClientsViewController
        // View Model create & setup
        if let nc = self.navigationController {
            let remoteDataSource = AdminRemoteDataStore()
            let repository = AdminRepository.init(remoteUserDataSource: remoteDataSource)
            let service = AdminService.init(adminRepository: repository)
            let navigator = ClientsNavigator(navigationController: nc)
            let viewModel = ClientsViewModel.init(service: service, navigator: navigator)
            remoteDataSource.delegate = repository
            repository.delegate = service
            service.delegate = viewModel
            vc.viewModel = viewModel
            viewModel.delegate = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
