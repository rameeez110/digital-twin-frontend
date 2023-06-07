//
//  Constants.swift
//  Sould
//
//  Created by Rameez Hasan on 19/09/2022.
//

import Foundation
import UIKit

struct Constants {

    struct API {
        static let baseURL = "http://99.79.178.210:3000/"
    }
    
    struct UserDefaultsKey{
        static var stayLoggedIn:String = "StayLoggedIn"
        static var archivedUser:String = "ArchivedUser"
        static var cultureCode = "SelectedCultureCode"
        static var lastLoggedinUserId = "lastLoggedinUserId"
        static var introView = "IntroImageView"
        static var selectedClientId = "SelectedClientId"
        static var isClientSelected = "IsClientSelected"
    }
        
    struct UserOnboarding {
        // Post Apis
        static let loginUser = "login"
        static let googleLogin = "login/google"
        static let appleLogin = "login/apple"
        static let registerUser = "register"
        static let forgetPassword = "forgotPassword"
        static let resetPassword = "resetPassword"
        
        // Get Apis
        static let verifyUser = "verify"
        static let getProfile = "profile"
        static let getClients = "users/clients"
        static let getUsers = "users/all"
        
        // Put Apis
        static let updateProfile = "profile"
        static let updateUserType = "users/userType"
        static let makeAdmin = "users/makeAdmin"
        static let removeAdmin = "users/removeAdmin"
        
        // Delete Apis
        static let deleteUser = "users/self"
        static let deleteOtherUser = "users"
    }
    
    struct MediaRoutes {
        static var uploadProfilePicture = "users/uploadImage"
    }
    
    struct FilterHouse {
        // Get Apis
        static var getFilters = "filters"
        static var getproperties = "properties/search"
        static var getPropertiesByLocation = "properties/search/location"
        static var getLikedDislikedProperties = "properties/selection"
        static var getClientLikedDislikedProperties = "properties/selection"
        
        // Put Apis
        static var updateFilters = "filters"
        
        // Post Apis
        static var markLikeOrDislike = "properties/action"
        
        // Delete Api's
        static var deleteLikedProperty = "properties/selection"
    }
    
    struct GoogleMap {
        static var geoCodeAPIBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
        static var getLatLong = "address"
    }
    
    struct Invites {
        // Get Apis
        static var getAcceptedInvites = "invitation/accepted"
        static var getPendingInvites = "invitation/pending"
        static var getReceivedInvites = "invitation/received"
        
        // Put Apis
        static var acceptInvite = "invitation/accept"
        static var rejectInvite = "invitation/reject"
        static var deleteInvite = "invitation/delete"
        
        // Post Apis
        static var sendInvite = "invitation"
    }
    
    struct Comments {
        // Get Apis
        static var getComments = "comment"
        static var getClientsComments = "comment/client"
        
        // Put Apis
        static var updateComment = "comment"
        
        // Post Apis
        static var addComment = "comment"
        
        // Delete Apis
        static var deleteComment = "comment"
    }
    
    struct Colors{
        static let baseGreenColor = UIColor(red: 0.00, green: 0.54, blue: 0.25, alpha: 1.00)
        static let navBarHomeColor = "009EEA"
        
    }
    
    struct NotificationsKey{
        static var selectHome:String = "selectHome"
    }
    
    struct NotificationCenterKey {
        static let homePageDataUpdateNotificationObserver = Notification.Name("HomePageDataUpdateNotificationObserver")
    }
}
