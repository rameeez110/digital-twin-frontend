//
//  AdminRemoteService.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import SwiftyJSON

class AdminRemoteService {
    static let sharedInstance = AdminRemoteService()
    
    func sendInvite(email: String,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = ["toUserEmail": email]
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.Invites.sendInvite, params: params, apiType: .Post,true, completionHandler: { (response) in
            
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
                        if let email = data["toUserEmail"]?.string{
                            completionHandler(email as AnyObject,nil)
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
    func updateInvite(invite: Invite,status: InviteStatus,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        var path = "\(Constants.Invites.acceptInvite)/\(invite.id)"
        if status == .Rejected {
            path = "\(Constants.Invites.rejectInvite)/\(invite.id)"
        } else if status == .Deleted {
            path = "\(Constants.Invites.deleteInvite)/\(invite.id)"
        }
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: [String: AnyObject](), apiType: .Put,true, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["failure"] != JSON.null {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "APi Error")
                    error.errorString = swiftyJson["failure"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let data = swiftyJson["success"].bool{
                        if let value = swiftyJson["message"].string {
                            completionHandler(value as AnyObject,nil)
                        }
                    } else {
                        if let value = swiftyJson["message"].string {
                            let error2 = CustomError.init(errorCode: 250, errorString: value)
                            completionHandler(nil,error2)
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
    func getClients(completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        NetworkManager.sharedInstance.sentRequestToServer(apiName: Constants.UserOnboarding.getClients, params: [String: AnyObject](), apiType: .Get, completionHandler: { (response) in
            
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
                            if let data = each["toUserId"].dictionary{
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
                                invite.toUser = fromUser
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
    func getComments(property: Property,completionHandler:@escaping (AnyObject?,CustomError?) -> Void) {
        var path = "\(Constants.Comments.getClientsComments)/\(property.id)"
        let shouldShowClients = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isClientSelected)
        if shouldShowClients {
            if let userId = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.selectedClientId), userId != "" {
                path = "\(Constants.Comments.getClientsComments)/\(property.id)"
            }
        }
        
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
                        var invites = [Comment]()
                        for each in data {
                            var invite = Comment()
                            if let value = each["id"].string {
                                invite.id = value
                            }
                            if let value = each["comment"].string {
                                invite.comment = value
                            }
                            if let value = each["propertyId"].string {
                                invite.propertyId = value
                            }

                            if let data = each["userId"].dictionary{
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
                                invite.user = fromUser
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


// Comments Flow
extension AdminRemoteService {
    func createEditComment(comment: Comment,property: Property,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let params = ["comment": comment.comment,"propertyId": property.id]
        var path = Constants.Comments.addComment
        var type = ApiType.Post
        if comment.id != "" {
            path = "\(Constants.Comments.updateComment)/\(comment.id)"
            type = .Put
        }
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: params, apiType: type,true, completionHandler: { (response) in
            
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
                        completionHandler(data as AnyObject,nil)
                    } else {
                        if let value = swiftyJson["message"].string {
                            let error2 = CustomError.init(errorCode: 250, errorString: value)
                            completionHandler(nil,error2)
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
    func deleteComment(comment: Comment,completionHandler:@escaping (AnyObject?,CustomError?) -> Void)
    {
        let path = "\(Constants.Comments.deleteComment)/\(comment.id)"
        
        NetworkManager.sharedInstance.sentRequestToServer(apiName: path, params: [String: AnyObject](), apiType: .Delete,true, completionHandler: { (response) in
            
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
                        completionHandler(data as AnyObject,nil)
                    } else {
                        if let value = swiftyJson["message"].string {
                            let error2 = CustomError.init(errorCode: 250, errorString: value)
                            completionHandler(nil,error2)
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
}
