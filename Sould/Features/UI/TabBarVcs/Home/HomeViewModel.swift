//
//  HomeViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func updatePropertyUI()
    func updateNavBar(count: Int)
}

// Protocol for view model will use it for wiring
protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var dataSource: [Property] {get set}
    var invites: [Invite] {get set}
    var currentPage: Int {get set}
    var pageLimit: Int {get set}
    var currentProperty: Property {get set}
    var currentPropertyImageIndex: Int {get set}
    
    func didSelectProperyCard(index: Int)
    func didSelectProperyImage(index: Int)
    func getProperties()
    func markLikeOrDislike(property: Property,status: Bool)
    func didTapProfile()
    func getPendingInvites()
}

final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    private let navigator: HomeNavigator
    private let filterService: FilterServiceProtocol
    var dataSource: [Property]
    var invites: [Invite]
    var currentPage: Int
    var pageLimit: Int
    var currentProperty: Property
    var currentPropertyImageIndex: Int

    init(service: FilterServiceProtocol,navigator: HomeNavigator, delegate: HomeViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.filterService = service
        self.dataSource = [Property]()
        self.currentPage = 1
        self.pageLimit = 10
        self.currentProperty = Property()
        self.currentPropertyImageIndex = 0
        self.invites = [Invite]()
    }

    func didSelectProperyCard(index: Int) {
        self.navigator.navigateToHomeDetail(data: self.dataSource[index])
    }
    func didSelectProperyImage(index: Int) {
        self.currentPropertyImageIndex = self.currentPropertyImageIndex + 1
    }
 
    func getProperties() {
        self.filterService.getProperties(page: self.currentPage, limit: self.pageLimit)
    }
    func markLikeOrDislike(property: Property,status: Bool) {
        self.filterService.markStatus(property: property,status: status)
    }
    func didTapProfile() {
        self.navigator.navigateToProfile(invites: self.invites)
    }
    func getPendingInvites() {
        self.filterService.getPendingInvites()
    }
}

extension HomeViewModel: FilterServiceDelegate {
    func didUpdatedFilters(filter: Filter) {
        self.getProperties()
    }
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didFetchedProperties(data: [Property]) {
        if Session.sharedInstance.properties == nil {
            Session.sharedInstance.properties = [Property]()
            if let pro = data.first {
                self.currentProperty = pro
            }
            Session.sharedInstance.properties!.append(contentsOf: data)
        } else {
            Session.sharedInstance.properties!.append(contentsOf: data)
        }
        self.dataSource = Session.sharedInstance.properties!
        self.delegate?.updatePropertyUI()
    }
    func didFetchedPendingInvites(invites: [Invite]) {
        self.invites = invites
        self.delegate?.updateNavBar(count: self.invites.count)
    }
}

