//
//  Property.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import UIKit

struct Property {
    var id = String()
    var listingId = String()
    var url = String()
    var nearBy = String()
    var features = String()
    var ownershipType = String()
    var poolType = String()
    var price = Int()
    var lease = Int()
    var leasePerUnit = String()
    var propertyType = String()
    var transactionType = String()
    var propertyDescription = String()
    var updatedDate = Date()
    var buildingData = Building()
    var landData = Land()
    var addressData = Address()
    var agents = [Agent]()
    var images = [String]()
    var likedStatus = Bool()
    var isDeleted = Bool()
    
    init() {
    }
}

struct Building {
    var bathroomTotal = String()
    var bedroomsTotal = String()
    var bedroomsAboveGround = String()
    var bedroomsBelowGround = String()
    var basementDevelopment = String()
    var basementType = String()
    var constructionStyleAttachment = String()
    var coolingType = String()
    var exteriorFinish = String()
    var fireplacePresent = String()
    var heatingFuel = String()
    var heatingType = String()
    var sizeInterior = String()
    var storiesTotal = String()
    var type = String()
    
    init() {
    }
}
struct Land {
    var totalSize = String()
    var acreage = String()
    var amenities = String()
    var sizeIrregular = String()
    
    init() {
    }
}
struct Address {
    var streetAddress = String()
    var addressLine1 = String()
    var streetNumber = String()
    var streetName = String()
    var streetSuffix = String()
    var city = String()
    var province = String()
    var postalCode = String()
    var country = String()
    var communityName = String()
    var longitude = String()
    var latitude = String()
    
    init() {
    }
}
struct Agent {
    var name = String()
    var phone = String()
    var website = String()
    var office = String()
    var position = String()
}
