//
//  FilterRepository.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import Foundation
import UIKit

protocol FilterRepositoryDelegate: class {
    func didFailWithError(error: CustomError)
    func didFetchedFilters(filter: Filter)
    func didFetchedProperties(data: [Property])
    func didUpdatedFilters(filter: Filter)
    func didDeleteProperty(property: Property)
    func didFetchedPendingInvites(invites: [Invite])
}

protocol FilterRepositoryProtocol {
    var delegate: FilterRepositoryDelegate? { get set }
    func getFilters()
    func updateFilters(filter: Filter)
    func getProperties(page: Int,limit: Int)
    func markStatus(property: Property,status: Bool)
    func getLikedProperties()
    func deleteLikedProperty(data: Property)
    func getClientLikedProperties(user: String)
    func getPropertiesByLocation(page: Int,limit: Int,location: Location)
    func getPendingInvites()
}

final class FilterRepository: FilterRepositoryProtocol {
    weak var delegate: FilterRepositoryDelegate?
    private let filterDataSource: FilterRemoteDataStoreProtocol

    init(filterDataSource: FilterRemoteDataStoreProtocol, delegate: FilterRepositoryDelegate? = nil) {
        self.filterDataSource = filterDataSource
        self.delegate = delegate
    }
    func getFilters() {
        self.filterDataSource.getFilters()
    }
    func updateFilters(filter: Filter) {
        self.filterDataSource.updateFilters(filter: filter)
    }
    func getProperties(page: Int,limit: Int) {
        self.filterDataSource.getProperties(page: page, limit: limit)
    }
    func markStatus(property: Property,status: Bool) {
        self.filterDataSource.markStatus(property: property, status: status)
    }
    func getLikedProperties() {
        self.filterDataSource.getLikedProperties()
    }
    func getClientLikedProperties(user: String) {
        self.filterDataSource.getClientLikedProperties(user: user)
    }
    func deleteLikedProperty(data: Property) {
        self.filterDataSource.deleteLikedProperty(data: data)
    }
    func getPropertiesByLocation(page: Int,limit: Int,location: Location) {
        self.filterDataSource.getPropertiesByLocation(page: page, limit: limit, location: location)
    }
    func getPendingInvites() {
        self.filterDataSource.getPendingInvites()
    }
}

extension FilterRepository: FilterRemoteDataStoreDelegate {
    // MARK:- User RemoteDataStoreDelegate
    func didFailWithError(error: CustomError){
        self.delegate?.didFailWithError(error: error)
    }
    func didFetchedFilters(filter: Filter) {
        self.delegate?.didFetchedFilters(filter: filter)
    }
    func didFetchedProperties(data: [Property]) {
        self.delegate?.didFetchedProperties(data: data)
    }
    func didUpdatedFilters(filter: Filter) {
        self.delegate?.didUpdatedFilters(filter: filter)
    }
    func didDeleteProperty(property: Property) {
        self.delegate?.didDeleteProperty(property: property)
    }
    func didFetchedPendingInvites(invites: [Invite]) {
        self.delegate?.didFetchedPendingInvites(invites: invites)
    }
}
