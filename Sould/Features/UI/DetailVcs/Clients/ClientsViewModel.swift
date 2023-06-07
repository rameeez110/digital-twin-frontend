//
//  ClientsViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 04/02/2023.
//

import UIKit

protocol ClientsViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func reloadClients()
}

// Protocol for view model will use it for wiring
protocol ClientsViewModelProtocol {
    var delegate: ClientsViewModelDelegate? { get set }
    var dataSource: [Invite] {get set}
    
    func getClients()
    func goBack()
}

final class ClientsViewModel: ClientsViewModelProtocol {
    
    weak var delegate: ClientsViewModelDelegate?
    private let navigator: ClientsNavigator
    private let adminService: AdminServiceProtocol
    var dataSource: [Invite]

    init(service: AdminServiceProtocol,navigator: ClientsNavigator, delegate: ClientsViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.adminService = service
        self.dataSource = [Invite]()
    }
    func getClients() {
        self.adminService.getClients()
    }
    func goBack() {
        self.navigator.goBack()
    }
}

extension ClientsViewModel: AdminServiceDelegate {
    func didFailWithError(error: CustomError) {
        
    }
    func didFetchedClients(clients: [Invite]) {
        self.dataSource = clients
        self.delegate?.reloadClients()
    }
}
