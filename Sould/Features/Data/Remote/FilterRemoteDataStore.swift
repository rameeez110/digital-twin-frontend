//
//  FilterRemoteDataStore.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import Foundation
import UIKit

protocol FilterRemoteDataStoreDelegate: class {
    func didFailWithError(error: CustomError)
    func didFetchedFilters(filter: Filter)
    func didUpdatedFilters(filter: Filter)
    func didFetchedProperties(data: [Property])
    func didDeleteProperty(property: Property)
    func didFetchedPendingInvites(invites: [Invite])
}

protocol FilterRemoteDataStoreProtocol {
    var delegate: FilterRemoteDataStoreDelegate? { get set }
    func getFilters()
    func getProperties(page: Int,limit: Int)
    func updateFilters(filter: Filter)
    func markStatus(property: Property,status: Bool)
    func getLikedProperties()
    func getClientLikedProperties(user: String)
    func deleteLikedProperty(data: Property)
    func getPropertiesByLocation(page: Int,limit: Int,location: Location)
    func getPendingInvites()
}

final class FilterRemoteDataStore: FilterRemoteDataStoreProtocol {
    
    weak var delegate: FilterRemoteDataStoreDelegate?
    
    init(delegate: FilterRemoteDataStoreDelegate? = nil) {
        self.delegate = delegate
    }
    
    func getFilters() {
        FilterRemoteService.sharedInstance.getFilters { (response, error) in
            if error == nil{
                if let id = response as? Filter {
                    self.delegate?.didFetchedFilters(filter: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getLikedProperties() {
        FilterRemoteService.sharedInstance.getLikedProperties{ (response, error) in
            if error == nil{
                if let id = response as? [Property] {
                    self.delegate?.didFetchedProperties(data: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getClientLikedProperties(user: String) {
        FilterRemoteService.sharedInstance.getClientLikedProperties(clientId: user){ (response, error) in
            if error == nil{
                if let id = response as? [Property] {
                    self.delegate?.didFetchedProperties(data: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getProperties(page: Int,limit: Int) {
        FilterRemoteService.sharedInstance.getProperties(page: page, limit: limit) { (response, error) in
            if error == nil{
                if let id = response as? [Property] {
                    self.delegate?.didFetchedProperties(data: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func updateFilters(filter: Filter) {
        FilterRemoteService.sharedInstance.updateFilters(filter: filter) { (response, error) in
            if error == nil{
                if let id = response as? Filter {
                    self.delegate?.didUpdatedFilters(filter: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func markStatus(property: Property,status: Bool) {
        FilterRemoteService.sharedInstance.markStatus(property: property,status: status) { (response, error) in
            if error == nil{
                if let id = response as? Filter {
                    self.delegate?.didUpdatedFilters(filter: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func deleteLikedProperty(data: Property) {
        FilterRemoteService.sharedInstance.deleteLikedDisliked(property: data) { (response, error) in
            if error == nil{
                if let id = response as? Property {
                    self.delegate?.didDeleteProperty(property: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getPropertiesByLocation(page: Int,limit: Int,location: Location) {
        FilterRemoteService.sharedInstance.getPropertiesByLocation(page: page, limit: limit, location: location) { (response, error) in
            if error == nil{
                if let id = response as? [Property] {
                    self.delegate?.didFetchedProperties(data: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getPendingInvites() {
        AdminRemoteService.sharedInstance.getInvites{ (response, error) in
            if error == nil{
                if let id = response as? [Invite] {
                    let invites = id.filter({$0.status == false})
                    self.delegate?.didFetchedPendingInvites(invites: invites)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
}
