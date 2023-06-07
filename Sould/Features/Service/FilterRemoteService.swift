//
//  FilterRemoteService.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import SwiftyJSON

class FilterRemoteService {
    static let sharedInstance = FilterRemoteService()
    
    func updateFilters(filter: Filter,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.FilterHouse.updateFilters, params: filter.dictionary, apiType: .Put,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        print(data)
                        completionHandler(filter as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func getFilters(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.FilterHouse.getFilters, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        var filter = Filter()
                        if let value = data["city"]?.string{
                            filter.city = value
                        }
                        if let value = data["streetAddress"]?.string{
                            filter.address = value
                        }
                        if let value = data["parking"]?.array{
                            var bedroom = Ranges()
                            if let min = value.first?.int {
                                bedroom.min = min
                            }
                            if let max = value.last?.int {
                                bedroom.max = max
                            }
                            filter.parking = bedroom
                        }
                        if let value = data["bedroom"]?.array{
                            var bedroom = Ranges()
                            if let min = value.first?.int {
                                bedroom.min = min
                            }
                            if let max = value.last?.int {
                                bedroom.max = max
                            }
                            filter.bedRoom = bedroom
                        }
                        if let value = data["bathroom"]?.array{
                            var bathRoom = Ranges()
                            if let min = value.first?.int {
                                bathRoom.min = min
                            }
                            if let max = value.last?.int {
                                bathRoom.max = max
                            }
                            filter.bathRoom = bathRoom
                        }
                        if let value = data["priceRange"]?.dictionary{
                            var price = Ranges()
                            if let value = value["min"]?.int{
                                price.min = value
                            }
                            if let value = value["max"]?.int{
                                price.max = value
                            }
                            filter.price = price
                        }
                        if let value = data["location"]?.dictionary{
                            var price = Location()
                            if let value = value["latitude"]?.double{
                                price.lat = String(value)
                            }
                            if let value = value["longitude"]?.double{
                                price.long = String(value)
                            }
                            if let value = value["radius"]?.int{
                                price.radius = value
                            }
                            filter.location = price
                        }
                        if let value = data["keywords"]?.array{
                            var keywords = [String]()
                            for each in value {
                                if let keyword = each.string {
                                    keywords.append(keyword)
                                }
                            }
                            filter.keywords = keywords
                        }
                        if let value = data["houseType"]?.array{
                            var types = [HouseType]()
                            for each in value {
                                if let type = each.int {
                                    types.append(HouseType(rawValue: type) ?? .Detached)
                                }
                            }
                            filter.houseTypes = types
                        }
                        completionHandler(filter as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func getProperties(page: Int,limit: Int,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let path = "\(Constants.FilterHouse.getproperties)?page=\(page)&limit=\(limit)"
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        var properties = [Property]()
                        if let docs = data["docs"]?.array {
                            for each in docs {
                                var property = Property()
                                if let value = each["id"].string {
                                    property.id = value
                                }
                                if let value = each["isDeleted"].bool {
                                    property.isDeleted = value
                                }
                                if let images = each["images"].array{
                                    var imagesData = [String]()
                                    for each in images {
                                        if let keyword = each.string {
                                            imagesData.append(keyword)
                                        }
                                    }
                                    property.images = imagesData
                                }
                                if let building = each["building"].dictionary {
                                    var build = Building()
                                    if let value = building["bathroomTotal"]?.string {
                                        build.bathroomTotal = value
                                    }
                                    if let value = building["bedroomsTotal"]?.string {
                                        build.bedroomsTotal = value
                                    }
                                    if let value = building["bedroomsAboveGround"]?.string {
                                        build.bedroomsAboveGround = value
                                    }
                                    if let value = building["bedroomsBelowGround"]?.string {
                                        build.bedroomsBelowGround = value
                                    }
                                    if let value = building["basementDevelopment"]?.string {
                                        build.basementDevelopment = value
                                    }
                                    if let value = building["basementType"]?.string {
                                        build.basementType = value
                                    }
                                    if let value = building["constructionStyleAttachment"]?.string {
                                        build.constructionStyleAttachment = value
                                    }
                                    if let value = building["coolingType"]?.string {
                                        build.coolingType = value
                                    }
                                    if let value = building["exteriorFinish"]?.string {
                                        build.exteriorFinish = value
                                    }
                                    if let value = building["fireplacePresent"]?.string {
                                        build.fireplacePresent = value
                                    }
                                    if let value = building["heatingFuel"]?.string {
                                        build.heatingFuel = value
                                    }
                                    if let value = building["heatingType"]?.string {
                                        build.heatingType = value
                                    }
                                    if let value = building["sizeInterior"]?.string {
                                        build.sizeInterior = value
                                    }
                                    if let value = building["storiesTotal"]?.string {
                                        build.storiesTotal = value
                                    }
                                    if let value = building["type"]?.string {
                                        build.type = value
                                    }
                                    property.buildingData = build
                                }
                                if let agents = each["agent"].array {
                                    var agentData = [Agent]()
                                    for each in agents {
                                        var agent = Agent()
                                        if let value = each["name"].string {
                                            agent.name = value
                                        }
                                        if let value = each["position"].string {
                                            agent.position = value
                                        }
                                        if let value = each["websites"].dictionary {
                                            if let website = value["website"]?.dictionary {
                                                if let text = website["text"]?.string {
                                                    agent.website = text
                                                }
                                            }
                                        }
                                        if let value = each["phones"].array?.first?.dictionary {
                                            if let phone = value["text"]?.string {
                                                agent.phone = phone
                                            }
                                        }
                                        if let value = each["office"].array?.first?.dictionary {
                                            if let phone = value["name"]?.string {
                                                agent.office = phone
                                            }
                                        }
                                        agentData.append(agent)
                                    }
                                    property.agents = agentData
                                }
                                if let land = each["land"].dictionary {
                                    var landData = Land()
                                    if let value = land["sizeTotalText"]?.string {
                                        landData.totalSize = value
                                    }
                                    if let value = land["acreage"]?.string {
                                        landData.acreage = value
                                    }
                                    if let value = land["amenities"]?.string {
                                        landData.amenities = value
                                    }
                                    if let value = land["sizeIrregular"]?.string {
                                        landData.sizeIrregular = value
                                    }
                                    property.landData = landData
                                }
                                if let address = each["address"].dictionary {
                                    var addressData = Address()
                                    if let value = address["streetAddress"]?.string {
                                        addressData.streetAddress = value
                                    }
                                    if let value = address["addressLine1"]?.string {
                                        addressData.addressLine1 = value
                                    }
                                    if let value = address["streetNumber"]?.string {
                                        addressData.streetNumber = value
                                    }
                                    if let value = address["streetName"]?.string {
                                        addressData.streetName = value
                                    }
                                    if let value = address["streetSuffix"]?.string {
                                        addressData.streetSuffix = value
                                    }
                                    if let value = address["city"]?.string {
                                        addressData.city = value
                                    }
                                    if let value = address["province"]?.string {
                                        addressData.province = value
                                    }
                                    if let value = address["postalCode"]?.string {
                                        addressData.postalCode = value
                                    }
                                    if let value = address["country"]?.string {
                                        addressData.country = value
                                    }
                                    if let value = address["communityName"]?.string {
                                        addressData.communityName = value
                                    }
                                    if let value = address["longitude"]?.string {
                                        addressData.longitude = value
                                    }
                                    if let value = address["latitude"]?.string {
                                        addressData.latitude = value
                                    }
                                    property.addressData = addressData
                                }
                                if let value = each["listingId"].string {
                                    property.listingId = value
                                }
                                if let value = each["url"].string {
                                    property.url = value
                                }
                                if let value = each["nearBy"].string {
                                    property.nearBy = value
                                }
                                if let value = each["features"].string {
                                    property.features = value
                                }
                                if let value = each["ownershipType"].string {
                                    property.ownershipType = value
                                }
                                if let value = each["poolType"].string {
                                    property.poolType = value
                                }
                                if let value = each["price"].int {
                                    property.price = value
                                }
                                if let value = each["lease"].int {
                                    property.lease = value
                                }
                                if let value = each["leasePerUnit"].string {
                                    property.leasePerUnit = value
                                }
                                if let value = each["propertyType"].string {
                                    property.propertyType = value
                                }
                                if let value = each["transactionType"].string {
                                    property.transactionType = value
                                }
                                if let value = each["description"].string {
                                    property.propertyDescription = value
                                }
                                if let value = each["lastUpdated"].string {
                                    property.updatedDate = value.getDate()
                                }
                                properties.append(property)
                            }
                        }
                        completionHandler(properties as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func getPropertiesByLocation(page: Int,limit: Int,location: Location,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let path = "\(Constants.FilterHouse.getPropertiesByLocation)?page=\(page)&limit=\(limit)"
        let params = ["latitude": Double(location.lat) ?? Double(),"longitude": Double(location.long) ?? Double(),"radius": location.radius] as [String : Any]
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: params, apiType: .Post,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        var properties = [Property]()
                        if let docs = data["docs"]?.array {
                            properties = self.parseProperties(data: docs)
                        }
                        completionHandler(properties as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func getLikedProperties(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.FilterHouse.getLikedDislikedProperties, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].array{
                        var properties = [Property]()
                        for each in data {
                            var property = Property()
                            if let value = each["propertyId"].string {
                                property.id = value
                            }
                            if let value = each["status"].bool {
                                property.likedStatus = value
                            }
                            if let propertyServer = each["property"].dictionary {
                                if let images = propertyServer["images"]?.array{
                                    var imagesData = [String]()
                                    for each in images {
                                        if let keyword = each.string {
                                            imagesData.append(keyword)
                                        }
                                    }
                                    property.images = imagesData
                                }
                                if let value = propertyServer["isDeleted"]?.bool {
                                    property.isDeleted = value
                                }
                                if let building = propertyServer["building"]?.dictionary {
                                    var build = Building()
                                    if let value = building["bathroomTotal"]?.string {
                                        build.bathroomTotal = value
                                    }
                                    if let value = building["bedroomsTotal"]?.string {
                                        build.bedroomsTotal = value
                                    }
                                    if let value = building["bedroomsAboveGround"]?.string {
                                        build.bedroomsAboveGround = value
                                    }
                                    if let value = building["bedroomsBelowGround"]?.string {
                                        build.bedroomsBelowGround = value
                                    }
                                    if let value = building["basementDevelopment"]?.string {
                                        build.basementDevelopment = value
                                    }
                                    if let value = building["basementType"]?.string {
                                        build.basementType = value
                                    }
                                    if let value = building["constructionStyleAttachment"]?.string {
                                        build.constructionStyleAttachment = value
                                    }
                                    if let value = building["coolingType"]?.string {
                                        build.coolingType = value
                                    }
                                    if let value = building["exteriorFinish"]?.string {
                                        build.exteriorFinish = value
                                    }
                                    if let value = building["fireplacePresent"]?.string {
                                        build.fireplacePresent = value
                                    }
                                    if let value = building["heatingFuel"]?.string {
                                        build.heatingFuel = value
                                    }
                                    if let value = building["heatingType"]?.string {
                                        build.heatingType = value
                                    }
                                    if let value = building["sizeInterior"]?.string {
                                        build.sizeInterior = value
                                    }
                                    if let value = building["storiesTotal"]?.string {
                                        build.storiesTotal = value
                                    }
                                    if let value = building["type"]?.string {
                                        build.type = value
                                    }
                                    property.buildingData = build
                                }
                                if let land = propertyServer["land"]?.dictionary {
                                    var landData = Land()
                                    if let value = land["sizeTotalText"]?.string {
                                        landData.totalSize = value
                                    }
                                    if let value = land["acreage"]?.string {
                                        landData.acreage = value
                                    }
                                    if let value = land["amenities"]?.string {
                                        landData.amenities = value
                                    }
                                    if let value = land["sizeIrregular"]?.string {
                                        landData.sizeIrregular = value
                                    }
                                    property.landData = landData
                                }
                                if let address = propertyServer["address"]?.dictionary {
                                    var addressData = Address()
                                    if let value = address["streetAddress"]?.string {
                                        addressData.streetAddress = value
                                    }
                                    if let value = address["addressLine1"]?.string {
                                        addressData.addressLine1 = value
                                    }
                                    if let value = address["streetNumber"]?.string {
                                        addressData.streetNumber = value
                                    }
                                    if let value = address["streetName"]?.string {
                                        addressData.streetName = value
                                    }
                                    if let value = address["streetSuffix"]?.string {
                                        addressData.streetSuffix = value
                                    }
                                    if let value = address["city"]?.string {
                                        addressData.city = value
                                    }
                                    if let value = address["province"]?.string {
                                        addressData.province = value
                                    }
                                    if let value = address["postalCode"]?.string {
                                        addressData.postalCode = value
                                    }
                                    if let value = address["country"]?.string {
                                        addressData.country = value
                                    }
                                    if let value = address["communityName"]?.string {
                                        addressData.communityName = value
                                    }
                                    if let value = address["longitude"]?.string {
                                        addressData.longitude = value
                                    }
                                    if let value = address["latitude"]?.string {
                                        addressData.latitude = value
                                    }
                                    property.addressData = addressData
                                }
                                if let value = propertyServer["listingId"]?.string {
                                    property.listingId = value
                                }
                                if let value = propertyServer["url"]?.string {
                                    property.url = value
                                }
                                if let value = propertyServer["nearBy"]?.string {
                                    property.nearBy = value
                                }
                                if let value = propertyServer["features"]?.string {
                                    property.features = value
                                }
                                if let value = propertyServer["ownershipType"]?.string {
                                    property.ownershipType = value
                                }
                                if let value = propertyServer["poolType"]?.string {
                                    property.poolType = value
                                }
                                if let value = propertyServer["price"]?.int {
                                    property.price = value
                                }
                                if let value = propertyServer["lease"]?.int {
                                    property.lease = value
                                }
                                if let value = propertyServer["leasePerUnit"]?.string {
                                    property.leasePerUnit = value
                                }
                                if let value = propertyServer["propertyType"]?.string {
                                    property.propertyType = value
                                }
                                if let value = propertyServer["transactionType"]?.string {
                                    property.transactionType = value
                                }
                                if let value = propertyServer["description"]?.string {
                                    property.propertyDescription = value
                                }
                                if let value = propertyServer["lastUpdated"]?.string {
                                    property.updatedDate = value.getDate()
                                }
                            }
                            properties.append(property)
                        }
                        properties = properties.sorted { $0.updatedDate > $1.updatedDate }
                        completionHandler(properties as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func getClientLikedProperties(clientId: String,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let path = "\(Constants.FilterHouse.getClientLikedDislikedProperties)/\(clientId)"
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].array{
                        var properties = [Property]()
                        for each in data {
                            var property = Property()
                            if let value = each["propertyId"].string {
                                property.id = value
                            }
                            if let value = each["status"].bool {
                                property.likedStatus = value
                            }
                            if let propertyServer = each["property"].dictionary {
                                if let images = propertyServer["images"]?.array{
                                    var imagesData = [String]()
                                    for each in images {
                                        if let keyword = each.string {
                                            imagesData.append(keyword)
                                        }
                                    }
                                    property.images = imagesData
                                }
                                if let value = propertyServer["isDeleted"]?.bool {
                                    property.isDeleted = value
                                }
                                if let building = propertyServer["building"]?.dictionary {
                                    var build = Building()
                                    if let value = building["bathroomTotal"]?.string {
                                        build.bathroomTotal = value
                                    }
                                    if let value = building["bedroomsTotal"]?.string {
                                        build.bedroomsTotal = value
                                    }
                                    if let value = building["bedroomsAboveGround"]?.string {
                                        build.bedroomsAboveGround = value
                                    }
                                    if let value = building["bedroomsBelowGround"]?.string {
                                        build.bedroomsBelowGround = value
                                    }
                                    if let value = building["basementDevelopment"]?.string {
                                        build.basementDevelopment = value
                                    }
                                    if let value = building["basementType"]?.string {
                                        build.basementType = value
                                    }
                                    if let value = building["constructionStyleAttachment"]?.string {
                                        build.constructionStyleAttachment = value
                                    }
                                    if let value = building["coolingType"]?.string {
                                        build.coolingType = value
                                    }
                                    if let value = building["exteriorFinish"]?.string {
                                        build.exteriorFinish = value
                                    }
                                    if let value = building["fireplacePresent"]?.string {
                                        build.fireplacePresent = value
                                    }
                                    if let value = building["heatingFuel"]?.string {
                                        build.heatingFuel = value
                                    }
                                    if let value = building["heatingType"]?.string {
                                        build.heatingType = value
                                    }
                                    if let value = building["sizeInterior"]?.string {
                                        build.sizeInterior = value
                                    }
                                    if let value = building["storiesTotal"]?.string {
                                        build.storiesTotal = value
                                    }
                                    if let value = building["type"]?.string {
                                        build.type = value
                                    }
                                    property.buildingData = build
                                }
                                if let land = propertyServer["land"]?.dictionary {
                                    var landData = Land()
                                    if let value = land["sizeTotalText"]?.string {
                                        landData.totalSize = value
                                    }
                                    if let value = land["acreage"]?.string {
                                        landData.acreage = value
                                    }
                                    if let value = land["amenities"]?.string {
                                        landData.amenities = value
                                    }
                                    if let value = land["sizeIrregular"]?.string {
                                        landData.sizeIrregular = value
                                    }
                                    property.landData = landData
                                }
                                if let address = propertyServer["address"]?.dictionary {
                                    var addressData = Address()
                                    if let value = address["streetAddress"]?.string {
                                        addressData.streetAddress = value
                                    }
                                    if let value = address["addressLine1"]?.string {
                                        addressData.addressLine1 = value
                                    }
                                    if let value = address["streetNumber"]?.string {
                                        addressData.streetNumber = value
                                    }
                                    if let value = address["streetName"]?.string {
                                        addressData.streetName = value
                                    }
                                    if let value = address["streetSuffix"]?.string {
                                        addressData.streetSuffix = value
                                    }
                                    if let value = address["city"]?.string {
                                        addressData.city = value
                                    }
                                    if let value = address["province"]?.string {
                                        addressData.province = value
                                    }
                                    if let value = address["postalCode"]?.string {
                                        addressData.postalCode = value
                                    }
                                    if let value = address["country"]?.string {
                                        addressData.country = value
                                    }
                                    if let value = address["communityName"]?.string {
                                        addressData.communityName = value
                                    }
                                    if let value = address["longitude"]?.string {
                                        addressData.longitude = value
                                    }
                                    if let value = address["latitude"]?.string {
                                        addressData.latitude = value
                                    }
                                    property.addressData = addressData
                                }
                                if let value = propertyServer["listingId"]?.string {
                                    property.listingId = value
                                }
                                if let value = propertyServer["url"]?.string {
                                    property.url = value
                                }
                                if let value = propertyServer["nearBy"]?.string {
                                    property.nearBy = value
                                }
                                if let value = propertyServer["features"]?.string {
                                    property.features = value
                                }
                                if let value = propertyServer["ownershipType"]?.string {
                                    property.ownershipType = value
                                }
                                if let value = propertyServer["poolType"]?.string {
                                    property.poolType = value
                                }
                                if let value = propertyServer["price"]?.int {
                                    property.price = value
                                }
                                if let value = propertyServer["lease"]?.int {
                                    property.lease = value
                                }
                                if let value = propertyServer["leasePerUnit"]?.string {
                                    property.leasePerUnit = value
                                }
                                if let value = propertyServer["propertyType"]?.string {
                                    property.propertyType = value
                                }
                                if let value = propertyServer["transactionType"]?.string {
                                    property.transactionType = value
                                }
                                if let value = propertyServer["description"]?.string {
                                    property.propertyDescription = value
                                }
                                if let value = propertyServer["lastUpdated"]?.string {
                                    property.updatedDate = value.getDate()
                                }
                            }
                            properties.append(property)
                        }
                        properties = properties.sorted { $0.updatedDate > $1.updatedDate }
                        completionHandler(properties as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func markStatus(property: Property,status: Bool,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = ["propertyId":property.id,"status": status] as [String : Any]
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.FilterHouse.markLikeOrDislike, params: params, apiType: .Post,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        print(data)
                        completionHandler(property as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func deleteLikedDisliked(property: Property,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let path = "\(Constants.FilterHouse.deleteLikedProperty)/\(property.id)"
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: [String:AnyObject](), apiType: .Delete,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["success"].bool{
                        print(data)
                        completionHandler(property as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
    func getInvites(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.Invites.getReceivedInvites, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["message"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].array{
                        var invites = [Invite]()
                        for each in data {
                            var invite = Invite()
                            if let value = each["id"].string {
                                invite.id = value
                            }
                            invite.status = each["status"].boolValue
                            if let value = each["toUserEmail"].string {
                                invite.email = value
                            }
                            if let data = each["fromUserId"].dictionary{
                                var fromUser = User()
                                if let value = data["socialSignIn"]?.bool {
                                    fromUser.socialSignIn = value
                                }
                                if let value = data["hasTemporaryPassword"]?.bool {
                                    fromUser.hasTemporaryPassword = value
                                }
                                if let value = data["id"]?.string {
                                    fromUser.userId = value
                                }
                                if let value = data["email"]?.string {
                                    fromUser.email = value
                                }
                                if let value = data["phone"]?.string {
                                    fromUser.phone = value
                                }
                                if let value = data["firstName"]?.string {
                                    fromUser.firstName = value
                                }
                                if let value = data["imageUrl"]?.string {
                                    fromUser.image = value
                                }
                                if let value = data["lastName"]?.string {
                                    fromUser.lastName = value
                                }
                                if let value = data["userType"]?.int {
                                    fromUser.userType = UserType(rawValue: value) ?? .Visitor
                                }
                                if let value = data["role"]?.int {
                                    fromUser.userRole = UserRole(rawValue: value) ?? .User
                                }
                                if let value = data["isVerified"]?.bool {
                                    fromUser.isVerified = value
                                }
                                if let value = data["isFirstLogin"]?.bool {
                                    fromUser.isFirstLogin = value
                                }
                                invite.fromUser = fromUser
                            }
                            invites.append(invite)
                        }
                        completionHandler(invites as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
}

// mapping
extension FilterRemoteService {
    func parseProperties(data: [JSON]) -> [Property] {
        var properties = [Property]()
        for each in data {
            var property = Property()
            if let value = each["id"].string {
                property.id = value
            }
            if let value = each["isDeleted"].bool {
                property.isDeleted = value
            }
            if let images = each["images"].array{
                var imagesData = [String]()
                for each in images {
                    if let keyword = each.string {
                        imagesData.append(keyword)
                    }
                }
                property.images = imagesData
            }
            if let building = each["building"].dictionary {
                var build = Building()
                if let value = building["bathroomTotal"]?.string {
                    build.bathroomTotal = value
                }
                if let value = building["bedroomsTotal"]?.string {
                    build.bedroomsTotal = value
                }
                if let value = building["bedroomsAboveGround"]?.string {
                    build.bedroomsAboveGround = value
                }
                if let value = building["bedroomsBelowGround"]?.string {
                    build.bedroomsBelowGround = value
                }
                if let value = building["basementDevelopment"]?.string {
                    build.basementDevelopment = value
                }
                if let value = building["basementType"]?.string {
                    build.basementType = value
                }
                if let value = building["constructionStyleAttachment"]?.string {
                    build.constructionStyleAttachment = value
                }
                if let value = building["coolingType"]?.string {
                    build.coolingType = value
                }
                if let value = building["exteriorFinish"]?.string {
                    build.exteriorFinish = value
                }
                if let value = building["fireplacePresent"]?.string {
                    build.fireplacePresent = value
                }
                if let value = building["heatingFuel"]?.string {
                    build.heatingFuel = value
                }
                if let value = building["heatingType"]?.string {
                    build.heatingType = value
                }
                if let value = building["sizeInterior"]?.string {
                    build.sizeInterior = value
                }
                if let value = building["storiesTotal"]?.string {
                    build.storiesTotal = value
                }
                if let value = building["type"]?.string {
                    build.type = value
                }
                property.buildingData = build
            }
            if let agents = each["agent"].array {
                var agentData = [Agent]()
                for each in agents {
                    var agent = Agent()
                    if let value = each["name"].string {
                        agent.name = value
                    }
                    if let value = each["position"].string {
                        agent.position = value
                    }
                    if let value = each["websites"].dictionary {
                        if let website = value["website"]?.dictionary {
                            if let text = website["text"]?.string {
                                agent.website = text
                            }
                        }
                    }
                    if let value = each["phones"].array?.first?.dictionary {
                        if let phone = value["text"]?.string {
                            agent.phone = phone
                        }
                    }
                    if let value = each["office"].array?.first?.dictionary {
                        if let phone = value["name"]?.string {
                            agent.office = phone
                        }
                    }
                    agentData.append(agent)
                }
                property.agents = agentData
            }
            if let land = each["land"].dictionary {
                var landData = Land()
                if let value = land["sizeTotalText"]?.string {
                    landData.totalSize = value
                }
                if let value = land["acreage"]?.string {
                    landData.acreage = value
                }
                if let value = land["amenities"]?.string {
                    landData.amenities = value
                }
                if let value = land["sizeIrregular"]?.string {
                    landData.sizeIrregular = value
                }
                property.landData = landData
            }
            if let address = each["address"].dictionary {
                var addressData = Address()
                if let value = address["streetAddress"]?.string {
                    addressData.streetAddress = value
                }
                if let value = address["addressLine1"]?.string {
                    addressData.addressLine1 = value
                }
                if let value = address["streetNumber"]?.string {
                    addressData.streetNumber = value
                }
                if let value = address["streetName"]?.string {
                    addressData.streetName = value
                }
                if let value = address["streetSuffix"]?.string {
                    addressData.streetSuffix = value
                }
                if let value = address["city"]?.string {
                    addressData.city = value
                }
                if let value = address["province"]?.string {
                    addressData.province = value
                }
                if let value = address["postalCode"]?.string {
                    addressData.postalCode = value
                }
                if let value = address["country"]?.string {
                    addressData.country = value
                }
                if let value = address["communityName"]?.string {
                    addressData.communityName = value
                }
                if let value = address["longitude"]?.string {
                    addressData.longitude = value
                }
                if let value = address["latitude"]?.string {
                    addressData.latitude = value
                }
                property.addressData = addressData
            }
            if let value = each["listingId"].string {
                property.listingId = value
            }
            if let value = each["url"].string {
                property.url = value
            }
            if let value = each["nearBy"].string {
                property.nearBy = value
            }
            if let value = each["features"].string {
                property.features = value
            }
            if let value = each["ownershipType"].string {
                property.ownershipType = value
            }
            if let value = each["poolType"].string {
                property.poolType = value
            }
            if let value = each["price"].int {
                property.price = value
            }
            if let value = each["lease"].int {
                property.lease = value
            }
            if let value = each["leasePerUnit"].string {
                property.leasePerUnit = value
            }
            if let value = each["propertyType"].string {
                property.propertyType = value
            }
            if let value = each["transactionType"].string {
                property.transactionType = value
            }
            if let value = each["description"].string {
                property.propertyDescription = value
            }
            if let value = each["lastUpdated"].string {
                property.updatedDate = value.getDate()
            }
            properties.append(property)
        }
        return properties
    }
}
