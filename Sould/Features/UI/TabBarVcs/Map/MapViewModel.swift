//
//  MapViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

protocol MapViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func updatePropertyUI()
}

// Protocol for view model will use it for wiring
protocol MapViewModelProtocol {
    var delegate: MapViewModelDelegate? { get set }
    var dataSource: [Property]? { get set }
    
    func getDataSource()
    func getProperties(location: Location)
    func navigateToHomeDetail(property: Property)
}

final class MapViewModel: MapViewModelProtocol {
    
    weak var delegate: MapViewModelDelegate?
    private let navigator: MapNavigator
    private let filterService: FilterServiceProtocol
    var dataSource: [Property]?

    init(service: FilterServiceProtocol,navigator: MapNavigator, delegate: MapViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.filterService = service
        self.dataSource = Session.sharedInstance.properties
    }
    
    func getDataSource() {
        self.dataSource = Session.sharedInstance.properties
    }
    func getProperties(location: Location) {
        self.filterService.getPropertiesByLocation(page: 1, limit: 25, location: location)
    }
    func navigateToHomeDetail(property: Property) {
        self.navigator.navigateToHomeDetail(data: property)
    }
}

extension MapViewModel: FilterServiceDelegate {
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didFetchedProperties(data: [Property]) {
        self.dataSource = data
        self.delegate?.updatePropertyUI()
    }
}
