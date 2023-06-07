//
//  InvitesViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit

protocol InvitesViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func reloadInvites()
    func showToastView(message: String)
}

// Protocol for view model will use it for wiring
protocol InvitesViewModelProtocol {
    var delegate: InvitesViewModelDelegate? { get set }
    var dataSource: [Invite] {get set}
    var filteredDataSource: [Invite] {get set}
    var selectedType: InviteStatus {get set}
    
    func getInvites()
    func acceptInvite(invite: Invite)
    func rejectInvite(invite: Invite)
    func deleteInvite(invite: Invite)
    func updateDataSource()
}

final class InvitesViewModel: InvitesViewModelProtocol {
    
    weak var delegate: InvitesViewModelDelegate?
    private let navigator: ProfileNavigator
    private let adminService: AdminServiceProtocol
    var dataSource: [Invite]
    var filteredDataSource: [Invite]
    var selectedType: InviteStatus

    init(service: AdminServiceProtocol,navigator: ProfileNavigator, delegate: InvitesViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.adminService = service
        self.dataSource = [Invite]()
        self.selectedType = .Accepted
        self.filteredDataSource = [Invite]()
    }
    func getInvites() {
        self.adminService.getInvites()
    }
    func acceptInvite(invite: Invite) {
        self.adminService.acceptInvite(invite: invite)
    }
    func rejectInvite(invite: Invite) {
        self.adminService.rejectInvite(invite: invite)
    }
    func deleteInvite(invite: Invite) {
        self.adminService.deleteInvite(invite: invite)
    }
    func updateDataSource() {
        self.filteredDataSource = self.getFilteredDataSource()
    }
    func getFilteredDataSource() -> [Invite] {
//        if self.selectedType == .Accepted {
//            return self.dataSource.filter({$0.status == true})
//        } else {
//            return self.dataSource.filter({$0.status == false})
//        }
        return self.dataSource
    }
}

extension InvitesViewModel: AdminServiceDelegate {
    func didFailWithError(error: CustomError) {
        self.delegate?.validationError(error: error.errorString)
    }
    func didFetchedInvites(invites: [Invite]) {
        self.dataSource = invites
        self.updateDataSource()
        self.delegate?.reloadInvites()
    }
    func didUpdatedInvite(invite: String) {
        self.delegate?.showToastView(message: invite)
        self.getInvites()
    }
}

