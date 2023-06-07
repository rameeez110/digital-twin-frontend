//
//  UserRemoteService.swift
//  Sould
//
//  Created by Rameez Hasan on 19/09/2022.
//

import SwiftyJSON

class UserRemoteService {
    static let sharedInstance = UserRemoteService()
    
    func loginUser(user: User,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.loginUser, params: user.dictionary, apiType: .Post,true, completionHandler: { (response) in
            
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
                        let user = User()
                        if let value = data["token"]?.string {
                            user.token = value
                        }
                        if let data = data["user"]?.dictionary{
                            if let value = data["socialSignIn"]?.bool {
                                user.socialSignIn = value
                            }
                            if let value = data["hasTemporaryPassword"]?.bool {
                                user.hasTemporaryPassword = value
                            }
                            if let value = data["id"]?.string {
                                user.userId = value
                            }
                            if let value = data["email"]?.string {
                                user.email = value
                            }
                            if let value = data["phone"]?.string {
                                user.phone = value
                            }
                            if let value = data["firstName"]?.string {
                                user.firstName = value
                            }
                            if let value = data["role"]?.int {
                                user.userRole = UserRole(rawValue: value) ?? .User
                            }
                            if let value = data["imageUrl"]?.string {
                                user.image = value
                            }
                            if let value = data["lastName"]?.string {
                                user.lastName = value
                            }
                            if let value = data["userType"]?.int {
                                user.userType = UserType(rawValue: value) ?? .Visitor
                            }
                            if let value = data["isVerified"]?.bool {
                                user.isVerified = value
                            }
                            if let value = data["isFirstLogin"]?.bool {
                                user.isFirstLogin = value
                            }
                        }
                        completionHandler(user as AnyObject,nil)
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
    func registerUser(user: User,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.registerUser, params: user.registerDictionary, apiType: .Post,true, completionHandler: { (response) in
            
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
                        let newUser = user
                        if let value = data["socialSignIn"]?.bool {
                            newUser.socialSignIn = value
                        }
                        if let value = data["id"]?.string {
                            newUser.userId = value
                        }
                        if let value = data["userType"]?.int {
                            newUser.userType = UserType(rawValue: value) ?? .Visitor
                        }
                        if let value = data["role"]?.int {
                            newUser.userRole = UserRole(rawValue: value) ?? .User
                        }
                        if let value = data["isVerified"]?.bool {
                            newUser.isVerified = value
                        }
                        completionHandler(newUser as AnyObject,nil)
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
    func forgotPassowrd(email: String,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = ["email": email]
        let path = "\(Constants.UserOnboarding.forgetPassword)?email=\(email)"
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
                    if let data = swiftyJson["message"].string{
                        completionHandler(data as AnyObject,nil)
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
    func googleLogin(token: String,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = ["token": token]
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.googleLogin, params: params, apiType: .Post,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["failure"] != JSON.null {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["failure"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        let user = User()
                        if let value = data["token"]?.string {
                            user.token = value
                        }
                        if let data = data["user"]?.dictionary{
                            if let value = data["socialSignIn"]?.bool {
                                user.socialSignIn = value
                            }
                            if let value = data["id"]?.string {
                                user.userId = value
                            }
                            if let value = data["email"]?.string {
                                user.email = value
                            }
                            if let value = data["phone"]?.string {
                                user.phone = value
                            }
                            if let value = data["firstName"]?.string {
                                user.firstName = value
                            }
                            if let value = data["imageUrl"]?.string {
                                user.image = value
                            }
                            if let value = data["lastName"]?.string {
                                user.lastName = value
                            }
                            if let value = data["userType"]?.int {
                                user.userType = UserType(rawValue: value) ?? .Visitor
                            }
                            if let value = data["role"]?.int {
                                user.userRole = UserRole(rawValue: value) ?? .User
                            }
                            if let value = data["isVerified"]?.bool {
                                user.isVerified = value
                            }
                        }
                        completionHandler(user as AnyObject,nil)
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
    func appleLogin(token: String,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = ["token": token]
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.appleLogin, params: params, apiType: .Post,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["failure"] != JSON.null {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["failure"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        let user = User()
                        if let value = data["token"]?.string {
                            user.token = value
                        }
                        if let data = data["user"]?.dictionary{
                            if let value = data["socialSignIn"]?.bool {
                                user.socialSignIn = value
                            }
                            if let value = data["id"]?.string {
                                user.userId = value
                            }
                            if let value = data["email"]?.string {
                                user.email = value
                            }
                            if let value = data["phone"]?.string {
                                user.phone = value
                            }
                            if let value = data["firstName"]?.string {
                                user.firstName = value
                            }
                            if let value = data["imageUrl"]?.string {
                                user.image = value
                            }
                            if let value = data["lastName"]?.string {
                                user.lastName = value
                            }
                            if let value = data["userType"]?.int {
                                user.userType = UserType(rawValue: value) ?? .Visitor
                            }
                            if let value = data["role"]?.int {
                                user.userRole = UserRole(rawValue: value) ?? .User
                            }
                            if let value = data["isVerified"]?.bool {
                                user.isVerified = value
                            }
                        }
                        completionHandler(user as AnyObject,nil)
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
    func getProfile(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.getProfile, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
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
                        if let newUser = Session.sharedInstance.user {
                            if let value = data["socialSignIn"]?.bool {
                                newUser.socialSignIn = value
                            }
                            if let value = data["hasTemporaryPassword"]?.bool {
                                newUser.hasTemporaryPassword = value
                            }
                            if let value = data["id"]?.string {
                                newUser.userId = value
                            }
                            if let value = data["email"]?.string {
                                newUser.email = value
                            }
                            if let value = data["phone"]?.string {
                                newUser.phone = value
                            }
                            if let value = data["firstName"]?.string {
                                newUser.firstName = value
                            }
                            if let value = data["role"]?.int {
                                newUser.userRole = UserRole(rawValue: value) ?? .User
                            }
                            if let value = data["imageUrl"]?.string {
                                newUser.image = value
                            }
                            if let value = data["lastName"]?.string {
                                newUser.lastName = value
                            }
                            if let value = data["userType"]?.int {
                                newUser.userType = UserType(rawValue: value) ?? .Visitor
                            }
                            if let value = data["isVerified"]?.bool {
                                newUser.isVerified = value
                            }
                            if let value = data["isFirstLogin"]?.bool {
                                newUser.isFirstLogin = value
                            }
                            completionHandler(newUser as AnyObject,nil)
                        }
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
    func updateProfile(user: User,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.updateProfile, params: user.profileDictionary, apiType: .Put,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["failure"] != JSON.null {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["failure"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["data"].dictionary{
                        if let newUser = Session.sharedInstance.user {
                            if let value = data["firstName"]?.string {
                                newUser.firstName = value
                            }
                            if let value = data["lastName"]?.string {
                                newUser.lastName = value
                            }
                            if let value = data["phone"]?.string {
                                newUser.phone = value
                            }
                            if let value = data["imageUrl"]?.string {
                                newUser.image = value
                            }
                            completionHandler(newUser as AnyObject,nil)
                        }
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
    func updateUserType(type: UserType,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = [String: AnyObject]()
        let path = "\(Constants.UserOnboarding.updateUserType)/\(type.rawValue)"
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: params, apiType: .Put,true, completionHandler: { (response) in
            
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
                        if let newUser = Session.sharedInstance.user {
                            if let value = data["firstName"]?.string {
                                newUser.firstName = value
                            }
                            if let value = data["lastName"]?.string {
                                newUser.lastName = value
                            }
                            if let value = data["userType"]?.int {
                                newUser.userType = UserType(rawValue: value) ?? .Visitor
                            }
                            if let value = data["phone"]?.string {
                                newUser.phone = value
                            }
                            if let value = data["imageUrl"]?.string {
                                newUser.image = value
                            }
                            completionHandler(newUser as AnyObject,nil)
                        }
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
    func getAllUsers(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.getUsers, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
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
                        var invites = [User]()
                        for each in data {
                            var fromUser = User()
                            if let value = each["socialSignIn"].bool {
                                fromUser.socialSignIn = value
                            }
                            if let value = each["hasTemporaryPassword"].bool {
                                fromUser.hasTemporaryPassword = value
                            }
                            if let value = each["id"].string {
                                fromUser.userId = value
                            }
                            if let value = each["email"].string {
                                fromUser.email = value
                            }
                            if let value = each["phone"].string {
                                fromUser.phone = value
                            }
                            if let value = each["firstName"].string {
                                fromUser.firstName = value
                            }
                            if let value = each["imageUrl"].string {
                                fromUser.image = value
                            }
                            if let value = each["lastName"].string {
                                fromUser.lastName = value
                            }
                            if let value = each["userType"].int {
                                fromUser.userType = UserType(rawValue: value) ?? .Visitor
                            }
                            if let value = each["role"].int {
                                fromUser.userRole = UserRole(rawValue: value) ?? .User
                            }
                            if let value = each["isVerified"].bool {
                                fromUser.isVerified = value
                            }
                            if let value = each["isFirstLogin"].bool {
                                fromUser.isFirstLogin = value
                            }
                            invites.append(fromUser)
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
    func makeOrRemoveAdmin(user: User,isMaking: Bool,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        var path = "\(Constants.UserOnboarding.removeAdmin)/\(user.userId)"
        if isMaking {
            path = "\(Constants.UserOnboarding.makeAdmin)/\(user.userId)"
        }
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: user.profileDictionary, apiType: .Put,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["success"].bool == false {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["failure"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    completionHandler(true as AnyObject,nil)
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
    
    func deleteUser(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.deleteUser, params: [String:AnyObject](), apiType: .Delete,true, completionHandler: { (response) in
            
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
                        completionHandler(data as AnyObject,nil)
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
    func deleteOtherUser(user: User,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let path = "\(Constants.UserOnboarding.deleteOtherUser)/\(user.userId)"
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
                        completionHandler(data as AnyObject,nil)
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
