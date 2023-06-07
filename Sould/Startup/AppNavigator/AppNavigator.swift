//
//  AppNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 12/08/2022.
//

import UIKit

struct AppNavigator {

    func installRoot(into window: UIWindow) {
        // controller create & setup
        
        let storyboard = UIStoryboard(storyboard: .main)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        let rootController = AppNavigationController(rootViewController: vc)
        // View Model create & setup
        let remoteDataSource = UserRemoteDataStore()
        let repository = UserRepository.init(remoteUserDataSource: remoteDataSource)
        let service = UserService.init(userRepository: repository)
        let navigator = LoginNavigator(navigationController: rootController)
        let viewModel = LoginViewModel(user: User(), service: service, navigator: navigator)
        
        remoteDataSource.delegate = repository
        repository.delegate = service
        service.delegate = viewModel
        viewModel.delegate = vc
        vc.viewModel = viewModel
        
        window.rootViewController = rootController
    }
    
    func makeHomeRoot(into window: UIWindow){
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! UITabBarController
        
        let navController = AppNavigationController(rootViewController: tabBarVC)
        navController.navigationBar.isHidden = true
        
        let remoteDataSource = FilterRemoteDataStore()
        let repository = FilterRepository.init(filterDataSource: remoteDataSource)
        let service = FilterService.init(filterRepository: repository)
        
        let homeRemoteDataSource = FilterRemoteDataStore()
        let homeRepository = FilterRepository.init(filterDataSource: homeRemoteDataSource)
        let homeService = FilterService.init(filterRepository: homeRepository)
        
        let filterRemoteDataSource = FilterRemoteDataStore()
        let filterRepository = FilterRepository.init(filterDataSource: filterRemoteDataSource)
        let filterservice = FilterService.init(filterRepository: filterRepository)
        
        let messageRemoteDataSource = FilterRemoteDataStore()
        let messageRepository = FilterRepository.init(filterDataSource: messageRemoteDataSource)
        let messageservice = FilterService.init(filterRepository: messageRepository)
        
        remoteDataSource.delegate = repository
        repository.delegate = service
        
        filterRemoteDataSource.delegate = filterRepository
        filterRepository.delegate = filterservice
        homeRemoteDataSource.delegate = homeRepository
        homeRepository.delegate = homeService
        messageRemoteDataSource.delegate = messageRepository
        messageRepository.delegate = messageservice
        
        if let vcs = tabBarVC.viewControllers ,vcs.count > 0 {
            for each in vcs {
                if let navHome = each as? UINavigationController {
                    if let controller = navHome.viewControllers.first as? HomeViewController {
                        let homeviewModel = HomeViewModel(service: homeService, navigator: HomeNavigator(navigationController: navHome))
                        homeviewModel.delegate = controller
                        homeService.delegate = homeviewModel
                        controller.viewModel = homeviewModel
                        tabBarVC.delegate = controller
                    } else if let controller = navHome.viewControllers.first as? MapViewController {
                        let searchviewModel = MapViewModel(service: service, navigator: MapNavigator(navigationController: navHome))
                        searchviewModel.delegate = controller
                        service.delegate = searchviewModel
                        controller.viewModel = searchviewModel
                    } else if let controller = navHome.viewControllers.first as? MessageViewController {
                        let newpostviewModel = MessageViewModel(service: messageservice, navigator: MessageNavigator(navigationController: navHome))
                        newpostviewModel.delegate = controller
                        messageservice.delegate = newpostviewModel
                        controller.viewModel = newpostviewModel
                    }else if let controller = navHome.viewControllers.first as? FilterViewController {
                        let networkviewModel = FilterViewModel(service: filterservice, navigator: FilterNavigator(navigationController: navHome))
                        networkviewModel.delegate = controller
                        filterservice.delegate = networkviewModel
                        controller.viewModel = networkviewModel
                    }
                }
            }
        }
        
        window.rootViewController = navController
    }
}
