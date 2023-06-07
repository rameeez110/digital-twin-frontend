//
//  UserListingViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 09/02/2023.
//

import UIKit
protocol UserListingViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func reloadUsers()
    func showToastView(message: String)
}

// Protocol for view model will use it for wiring
protocol UserListingViewModelProtocol {
    var delegate: UserListingViewModelDelegate? { get set }
    var dataSource: [User] {get set}
    var filteredDataSource: [User] {get set}
    var searchTerm: String {get set}
    
    func getAllUsers()
    func removeAdmin(model: User)
    func makeAdmin(model: User)
    func goBack()
    func updateDataSource()
    func goToViewProfile(model: User)
    func deleteOtherUser(index: Int)
}

final class UserListingViewModel: UserListingViewModelProtocol {
    
    weak var delegate: UserListingViewModelDelegate?
    private let navigator: UserListingNavigator
    private let userService: UserServiceProtocol
    var dataSource: [User]
    var filteredDataSource: [User]
    var searchTerm: String

    init(service: UserServiceProtocol,navigator: UserListingNavigator, delegate: UserListingViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
        self.dataSource = [User]()
        self.filteredDataSource = [User]()
        self.searchTerm = ""
    }
    func getAllUsers() {
        self.userService.getAllUsers()
    }
    func goBack() {
        self.navigator.goBack()
    }
    func removeAdmin(model: User) {
        self.userService.removeAdmin(model: model)
    }
    func makeAdmin(model: User) {
        self.userService.makeAdmin(model: model)
    }
    func updateDataSource(){
        self.sortDataSource()
        if self.searchTerm == "" {
            self.filteredDataSource = self.dataSource
        } else {
            self.filteredDataSource = self.dataSource.filter({"\($0.firstName.lowercased()) \($0.lastName.lowercased()) ".contains(searchTerm.lowercased())})
        }
    }
    func goToViewProfile(model: User) {
        self.navigator.navigateToProfile(user: model)
    }
    func sortDataSource() {
        self.dataSource = self.dataSource.sorted { "\($0.firstName) \($0.lastName)" < "\($1.firstName) \($1.lastName)" }
    }
    func deleteOtherUser(index: Int) {
        self.userService.deleteOtherUser(user: self.filteredDataSource[index])
    }
}

extension UserListingViewModel: UserServiceDelegate {
    func didFailWithError(error: CustomError) {
        
    }
    func didUsersFetched(users: [User]) {
        self.dataSource = users
        self.updateDataSource()
        self.delegate?.reloadUsers()
    }
    func didAdminUpdated(message: String) {
        self.getAllUsers()
        self.delegate?.showToastView(message: message)
    }
}
