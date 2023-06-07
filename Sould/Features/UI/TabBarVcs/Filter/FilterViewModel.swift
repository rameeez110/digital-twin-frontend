//
//  FilterViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import SwiftLocation
import MapKit

enum FilterDataType: Int {
    case None = 0,Slider,RangeSlider,Tags
}

enum FilterType: Int {
    case City = 0,Bedroom,Bathroom,Parking,Price,Distance,Keywords,DefaultKeywords
}

struct KeyWord {
    var text = String()
    var isSelected = false
    
    init(text: String = String(), isSelected: Bool = false) {
        self.text = text
        self.isSelected = isSelected
    }
}

struct FilterViewModelDataSource {
    var title = String()
    var filterDataType = FilterDataType.None
    var type = FilterType.City
    var text = String()
    var min = Int()
    var max = Int()
    var keywords = [KeyWord]()
}

protocol FilterViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func reloadUI()
    func fetchedCoordinates(cord: CLLocationCoordinate2D)
    func updateNavbarUI(count: Int)
}

// Protocol for view model will use it for wiring
protocol FilterViewModelProtocol {
    var delegate: FilterViewModelDelegate? { get set }
    var dataSource: [FilterViewModelDataSource] {get set}
    var filter: Filter {get set}
    var invites: [Invite] {get set}
    
    func mapDataSource()
    func didTapProfile()
    func populateData()
    func updateFilters()
    func goToHome()
    func getPendingInvites()
    func getGeocodedCoordinates(address: String)
}

final class FilterViewModel: FilterViewModelProtocol {
    weak var delegate: FilterViewModelDelegate?
    private let navigator: FilterNavigator
    private let filterService: FilterServiceProtocol
    var dataSource: [FilterViewModelDataSource]
    var titles: [String]
    var types: [FilterDataType]
    var filter: Filter
    var invites: [Invite]

    init(service: FilterServiceProtocol,navigator: FilterNavigator, delegate: FilterViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.filterService = service
        self.dataSource = [FilterViewModelDataSource]()
        self.titles = ["Address","Bedrooms","Bathrooms","Parking","Price","Distance","Keywords",""]
        self.types = [FilterDataType.None,FilterDataType.RangeSlider,FilterDataType.RangeSlider,FilterDataType.RangeSlider,FilterDataType.RangeSlider,FilterDataType.RangeSlider,FilterDataType.Tags,FilterDataType.Tags]
        self.filter = Filter()
        self.invites = [Invite]()
    }

    func mapDataSource() {
        self.dataSource = [FilterViewModelDataSource]()
        for i in 0..<self.titles.count {
            var model = FilterViewModelDataSource()
            model.title = self.titles[i]
            model.filterDataType = self.types[i]
            model.type = FilterType(rawValue: i) ?? .City
            if model.type == .DefaultKeywords {
                model.keywords = [KeyWord(text: "Detached"),KeyWord(text: "Semi-Detached"),KeyWord(text: "Townhouse"),KeyWord(text: "Condo"),KeyWord(text: "Multiplex"),KeyWord(text: "Other")]
            }
            self.dataSource.append(model)
        }
    }
    func didTapProfile() {
        self.navigator.navigateToProfile(invites: self.invites)
    }
    func goToHome() {
        self.navigator.navigateToHome()
    }
    func populateData() {
        self.filterService.getFilters()
    }
    func updateFilters() {
        self.filterService.updateFilters(filter: self.filter)
    }
    func getPendingInvites() {
        self.filterService.getPendingInvites()
    }
    func getGeocodedCoordinates(address: String) {
        SwiftLocation.credentials[.google] = "AIzaSyBv021fbIY4Rs2wdONNxDdKqok5hgTeH6U"
        let service = Geocoder.Google(address: address)
        SwiftLocation.geocodeWith(service).then { result in
            // ...
            if let coordinates = result.data?.first {
                self.filter.location.lat = "\(coordinates.coordinates.latitude)"
                self.filter.location.long = "\(coordinates.coordinates.longitude)"
                self.delegate?.fetchedCoordinates(cord: coordinates.coordinates)
            }
        }
    }
}

extension FilterViewModel: FilterServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didFetchedFilters(filter: Filter) {
        let lat = self.filter.location.lat
        let long = self.filter.location.long
        self.filter = filter
        if lat != "" {
            self.filter.location.lat = lat
        }
        if long != "" {
            self.filter.location.long = long
        }
        if self.dataSource.count > 6 {
            self.dataSource[6].keywords = [KeyWord]()
            for each in self.filter.keywords {
                self.dataSource[6].keywords.append(KeyWord(text: each))
            }
        }
        if self.dataSource.count > 7 {
            for each in self.filter.houseTypes {
                switch each {
                case .Detached:
                    self.dataSource[7].keywords[0].isSelected = true
                case .SemiDetached:
                    self.dataSource[7].keywords[1].isSelected = true
                case .Townhouse:
                    self.dataSource[7].keywords[2].isSelected = true
                case .Condo:
                    self.dataSource[7].keywords[3].isSelected = true
                case .Multiplex:
                    self.dataSource[7].keywords[4].isSelected = true
                case .Other:
                    self.dataSource[7].keywords[5].isSelected = true
                }
            }
        }
        self.delegate?.reloadUI()
    }
    func didUpdatedFilters(filter: Filter) {
        NotificationCenter.default.post(name: Constants.NotificationCenterKey.homePageDataUpdateNotificationObserver, object: self, userInfo: nil)
        self.delegate?.hideInfoLabel()
    }
    func didFetchedPendingInvites(invites: [Invite]) {
        self.invites = invites
        self.delegate?.updateNavbarUI(count: invites.count)
    }
}
