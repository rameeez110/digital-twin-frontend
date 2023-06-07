//
//  Enums.swift
//  Sould
//
//  Created by Rameez Hasan on 20/09/2022.
//

import UIKit

enum ApiType: String {
    case Post = "Post"
    case Get = "Get"
    case Put = "Put"
    case Delete = "Delete"
}

enum UserType: Int {
    case Visitor = 1,Dealer
}

enum UserRole: Int {
    case SuperAdmin = 0,Admin,User
}

enum LikeStatus: Int {
    case Liked = 0,Disliked
}

enum HouseType: Int {
    case Detached = 0,SemiDetached,Townhouse,Condo,Multiplex,Other
}

enum HouseTypeString: String {
    case Detached = "Detached"
    case Semi = "Semi-Detached"
    case Town = "Townhouse"
    case Condo = "Condo"
    case Multiplex = "Multiplex"
    case Other = "Other"
}

enum InviteStatus: Int {
    case Accepted = 0,Pending,Rejected,Deleted
}
