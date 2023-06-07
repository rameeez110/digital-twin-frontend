//
//  FilterService.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import Foundation
import UIKit

protocol FilterServiceDelegate: class {
    func didFailWithError(error: CustomError)
    func didFetchedFilters(filter: Filter)
    func didFetchedProperties(data: [Property])
    func didUpdatedFilters(filter: Filter)
    func didDeleteProperty(property: Property)
    func didFetchedPendingInvites(invites: [Invite])
}

extension FilterServiceDelegate {
    func didFetchedFilters(filter: Filter) {}
    func didFetchedProperties(data: [Property]) {}
    func didUpdatedFilters(filter: Filter) {}
    func didDeleteProperty(property: Property) {}
    func didFetchedPendingInvites(invites: [Invite]) {}
}

protocol FilterServiceProtocol {
    var delegate: FilterServiceDelegate? { get set }
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

final class FilterService: FilterServiceProtocol {

    weak var delegate: FilterServiceDelegate?
    private let filterRepository: FilterRepositoryProtocol

    init(filterRepository: FilterRepositoryProtocol) {
        self.filterRepository = filterRepository
    }
    func getFilters() {
        self.filterRepository.getFilters()
    }
    func updateFilters(filter: Filter) {
        self.filterRepository.updateFilters(filter: filter)
    }
    func getProperties(page: Int,limit: Int) {
        self.filterRepository.getProperties(page: page,limit: limit)
    }
    func markStatus(property: Property,status: Bool) {
        self.filterRepository.markStatus(property: property, status: status)
    }
    func getLikedProperties() {
        self.filterRepository.getLikedProperties()
    }
    func getClientLikedProperties(user: String) {
        self.filterRepository.getClientLikedProperties(user: user)
    }
    func deleteLikedProperty(data: Property) {
        self.filterRepository.deleteLikedProperty(data: data)
    }
    func getPropertiesByLocation(page: Int,limit: Int,location: Location) {
        self.filterRepository.getPropertiesByLocation(page: page, limit: limit, location: location)
    }
    func getPendingInvites() {
        self.filterRepository.getPendingInvites()
    }
}

extension FilterService: FilterRepositoryDelegate {
    func didFailWithError(error: CustomError) {
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
