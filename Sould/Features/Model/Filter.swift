//
//  Filter.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import UIKit

struct Filter {
    var city = String()
    var address = String()
    var province = String()
    var bedRoom = Ranges()
    var bathRoom = Ranges()
    var parking = Ranges()
    var price = Ranges()
    var keywords = [String]()
    var userId = Int()
    var houseTypes = [HouseType]()
    var location = Location()
    
    init() {
        
    }
    
    var dictionary: [String: Any] {
        return [
            "streetAddress": /*"Toronto",*/self.address,
            "province": /*"Ontario",*/self.province,
            "bedroom": self.bedRoom.getRanges(),
            "bathroom": self.bathRoom.getRanges(),
            "parking": self.parking.getRanges(),
            "priceRange": self.price.dictionary,
            "keywords": self.keywords,
            "houseType": self.getSelectedTypes(),
            "location": self.location.dictionary,
        ]
    }
    
    func getSelectedTypes() -> [Int] {
        var types = [Int]()
        for each in self.houseTypes {
            types.append(each.rawValue)
        }
        return types
    }
}

struct Location {
    var lat = String()
    var long = String()
    var radius = Int()
    
    var dictionary: [String: Any] {
        return [
            "latitude": /*43.6532,*/Double(self.lat) ?? Double(),
            "longitude": /*-79.3832,*/Double(self.long) ?? Double(),
            "radius": self.radius,
        ]
    }
}

struct Ranges {
    var min = Int()
    var max = Int()
    
    func getRanges() -> [Int] {
        var ranges = [Int]()
        for i in self.min..<self.max + 1 {
            ranges.append(i)
        }
        if ranges.first == 0 && ranges.count == 1 {
            ranges = [Int]()
        }
        return ranges
    }
    
    var dictionary: [String: Any] {
        if self.min == 0 && self.max == 0 {
            return [String: Any]()
        }
        return [
            "min": self.min,
            "max": self.max,
        ]
    }
}
