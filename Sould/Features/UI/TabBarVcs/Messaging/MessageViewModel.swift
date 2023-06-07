//
//  MessageViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol MessageViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func reloadData()
}

// Protocol for view model will use it for wiring
protocol MessageViewModelProtocol {
    var delegate: MessageViewModelDelegate? { get set }
    var dataSource: [Property] {get set}
    var filteredDataSource: [Property] {get set}
    var selectedType: LikeStatus {get set}
    
    func updateDataSource()
    func getLikedProperties()
    func didSelectPropery(index: Int)
    func deleteLikedProperty(index: Int)
    func didTapClients()
}

final class MessageViewModel: MessageViewModelProtocol {
    weak var delegate: MessageViewModelDelegate?
    private let navigator: MessageNavigator
    private let filterService: FilterServiceProtocol
    var dataSource: [Property]
    var filteredDataSource: [Property]
    var selectedType: LikeStatus

    init(service: FilterServiceProtocol,navigator: MessageNavigator, delegate: MessageViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.filterService = service
        self.dataSource = [Property]()
        self.selectedType = .Liked
        self.filteredDataSource = [Property]()
    }
    
    func getLikedProperties() {
        let shouldShowClients = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isClientSelected)
        if shouldShowClients {
            if let userId = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.selectedClientId), userId != "" {
                self.filterService.getClientLikedProperties(user: userId)
            } else {
                self.filterService.getLikedProperties()
            }
        } else {
            self.filterService.getLikedProperties()
        }
    }
    func deleteLikedProperty(index: Int) {
        self.filterService.deleteLikedProperty(data: self.filteredDataSource[index])
    }
    func getFilteredDataSource() -> [Property] {
        if self.selectedType == .Liked {
            return self.dataSource.filter({$0.likedStatus == true})
        } else {
            return self.dataSource.filter({$0.likedStatus == false})
        }
    }
    func didSelectPropery(index: Int) {
        self.navigator.navigateToHomeDetail(data: self.filteredDataSource[index])
    }
    func didTapClients() {
        self.navigator.navigateToClients()
    }
}

extension MessageViewModel: FilterServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didFetchedProperties(data: [Property]) {
        self.dataSource = data
        self.updateDataSource()
        self.delegate?.reloadData()
    }
    func updateDataSource() {
        self.filteredDataSource = self.getFilteredDataSource()
    }
    func didDeleteProperty(property: Property) {
        if let index = self.dataSource.firstIndex(where: {$0.id == property.id}) {
            self.dataSource.remove(at: index)
            self.updateDataSource()
            self.delegate?.reloadData()
        }
    }
}
