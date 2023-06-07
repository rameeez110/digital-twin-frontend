//
//  UserRemoteDataStore.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import Foundation
import UIKit

protocol UserRemoteDataStoreDelegate: class {
    func didFailWithError(error: CustomError)
    func didLoggedIn(user: User)
    func didRegistered(user: User)
    func didForgetPassword(response: String)
    func profileUpdated(user: User)
    func imageUploaded(imageData: Attachment)
    func didProfileFetched(user: User)
    func didUsersFetched(users: [User])
    func didAdminUpdated(message: String)
    func didUserDeleted(message: String)
}

protocol UserRemoteDataStoreProtocol {
    var delegate: UserRemoteDataStoreDelegate? { get set }
    func loginUser(user: User)
    func registerUser(user: User)
    func forgetPassword(email: String)
    func googleLogin(token: String)
    func appleLogin(token: String)
    func updateProfile(user: User)
    func uploadProfileImage(image: UIImage)
    func updateUserType(type: UserType)
    func getProfile()
    func getAllUsers()
    func removeAdmin(model: User)
    func makeAdmin(model: User)
    func deleteOtherUser(user: User)
    func deleteUser()
}

final class UserRemoteDataStore: UserRemoteDataStoreProtocol {
  
    weak var delegate: UserRemoteDataStoreDelegate?

    init(delegate: UserRemoteDataStoreDelegate? = nil) {
        self.delegate = delegate
    }

    func loginUser(user: User) {
        UserRemoteService.sharedInstance.loginUser(user: user) { (response, error) in
            if error == nil{
                if let id = response as? User {
                    id.saveUser(user: id)
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.didLoggedIn(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func registerUser(user: User) {
        UserRemoteService.sharedInstance.registerUser(user: user) { (response, error) in
            if error == nil{
                if let id = response as? User {
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.didRegistered(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func forgetPassword(email: String) {
        UserRemoteService.sharedInstance.forgotPassowrd(email: email) { (response, error) in
            if error == nil{
                if let id = response as? String {
                    self.delegate?.didForgetPassword(response: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func googleLogin(token: String) {
        UserRemoteService.sharedInstance.googleLogin(token: token) { (response, error) in
            if error == nil{
                if let id = response as? User {
                    id.saveUser(user: id)
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.didLoggedIn(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func appleLogin(token: String) {
        UserRemoteService.sharedInstance.appleLogin(token: token) { (response, error) in
            if error == nil{
                if let id = response as? User {
                    id.saveUser(user: id)
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.didLoggedIn(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func updateProfile(user: User) {
        UserRemoteService.sharedInstance.updateProfile(user: user) { (response, error) in
            if error == nil{
                if let id = response as? User {
                    id.saveUser(user: id)
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.profileUpdated(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func uploadProfileImage(image: UIImage) {
        MediaService.sharedInstance.uploadImage(image: image) { (response, error) in
            if error == nil{
                if let model = response as? Attachment {
                    self.delegate?.imageUploaded(imageData: model)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func updateUserType(type: UserType) {
        UserRemoteService.sharedInstance.updateUserType(type: type) { (response, error) in
            if error == nil{
                if let id = response as? User {
                    id.saveUser(user: id)
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.profileUpdated(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getProfile() {
        UserRemoteService.sharedInstance.getProfile { (response, error) in
            if error == nil{
                if let id = response as? User {
                    id.saveUser(user: id)
                    Session.sharedInstance.user = id
                    Session.sharedInstance.token = id.token
                    self.delegate?.didProfileFetched(user: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getAllUsers() {
        UserRemoteService.sharedInstance.getAllUsers { (response, error) in
            if error == nil{
                if let id = response as? [User] {
                    self.delegate?.didUsersFetched(users: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func removeAdmin(model: User) {
        UserRemoteService.sharedInstance.makeOrRemoveAdmin(user: model, isMaking: false) { (response, error) in
            if error == nil{
                if let id = response as? Bool {
                    print(id)
                    self.delegate?.didAdminUpdated(message: "Admin removed successfully")
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func makeAdmin(model: User) {
        UserRemoteService.sharedInstance.makeOrRemoveAdmin(user: model, isMaking: true) { (response, error) in
            if error == nil{
                if let id = response as? Bool {
                    print(id)
                    self.delegate?.didAdminUpdated(message: "Admin updated successfully")
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func deleteOtherUser(user: User) {
        UserRemoteService.sharedInstance.deleteOtherUser(user: user) { (response, error) in
            if error == nil{
                if let id = response as? Bool {
                    print(id)
                    self.delegate?.didAdminUpdated(message: "Admin deleted user successfully")
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func deleteUser() {
        UserRemoteService.sharedInstance.deleteUser { (response, error) in
            if error == nil{
                if let id = response as? Bool {
                    print(id)
                    self.delegate?.didUserDeleted(message: "Admin deleted user successfully")
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
}
