//
//  MapNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol MapNavigatorProtocol {
    func navigateToHomeDetail(data: Property)
}


class MapNavigator: MapNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
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
}
