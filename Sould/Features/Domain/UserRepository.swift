//
//  UserRepository.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import Foundation
import UIKit

protocol UserRepositoryDelegate: class {
    func didFailWithError(error: CustomError)
    func didLoggedIn(user: User)
    func didRegistered(user: User)
    func didForgetPassword(response: String)
    func profileUpdated(user: User)
    func imageUploaded(image: Attachment)
    func didProfileFetched(user: User)
    func didUsersFetched(users: [User])
    func didAdminUpdated(message: String)
    func didUserDeleted(message: String)
}

protocol UserRepositoryProtocol {
    var delegate: UserRepositoryDelegate? { get set }
    func loginUser(user: User)
    func registerUser(user: User)
    func forgetPassword(email: String)
    func googleLogin(token: String)
    func appleLogin(token: String)
    func updateProfile(user: User)
    func uploadImage(image: UIImage)
    func updateUserType(type: UserType)
    func getProfile()
    func getAllUsers()
    func removeAdmin(model: User)
    func makeAdmin(model: User)
    func deleteOtherUser(user: User)
    func deleteUser()
}

final class UserRepository: UserRepositoryProtocol {
    weak var delegate: UserRepositoryDelegate?
    private let remoteUserDataSource: UserRemoteDataStoreProtocol

    init(remoteUserDataSource: UserRemoteDataStoreProtocol, delegate: UserRepositoryDelegate? = nil) {
        self.remoteUserDataSource = remoteUserDataSource
        self.delegate = delegate
    }
    func loginUser(user: User) {
        self.remoteUserDataSource.loginUser(user: user)
    }
    func registerUser(user: User) {
        self.remoteUserDataSource.registerUser(user: user)
    }
    func forgetPassword(email: String) {
        self.remoteUserDataSource.forgetPassword(email: email)
    }
    func googleLogin(token: String) {
        self.remoteUserDataSource.googleLogin(token: token)
    }
    func appleLogin(token: String) {
        self.remoteUserDataSource.appleLogin(token: token)
    }
    func updateProfile(user: User) {
        self.remoteUserDataSource.updateProfile(user: user)
    }
    func uploadImage(image: UIImage) {
        self.remoteUserDataSource.uploadProfileImage(image: image)
    }
    func updateUserType(type: UserType) {
        self.remoteUserDataSource.updateUserType(type: type)
    }
    func getProfile(){
        self.remoteUserDataSource.getProfile()
    }
    func getAllUsers() {
        self.remoteUserDataSource.getAllUsers()
    }
    func removeAdmin(model: User) {
        self.remoteUserDataSource.removeAdmin(model: model)
    }
    func makeAdmin(model: User) {
        self.remoteUserDataSource.makeAdmin(model: model)
    }
    func deleteOtherUser(user: User) {
        self.remoteUserDataSource.deleteOtherUser(user: user)
    }
    func deleteUser() {
        self.remoteUserDataSource.deleteUser()
    }
}

extension UserRepository: UserRemoteDataStoreDelegate {
    // MARK:- User RemoteDataStoreDelegate
    func didFailWithError(error: CustomError){
        self.delegate?.didFailWithError(error: error)
    }
    func didLoggedIn(user: User) {
        self.delegate?.didLoggedIn(user: user)
    }
    func didRegistered(user: User) {
        self.delegate?.didRegistered(user: user)
    }
    func didForgetPassword(response: String) {
        self.delegate?.didForgetPassword(response: response)
    }
    func profileUpdated(user: User) {
        self.delegate?.profileUpdated(user: user)
    }
    func imageUploaded(imageData: Attachment) {
        self.delegate?.imageUploaded(image: imageData)
    }
    func didProfileFetched(user: User) {
        self.delegate?.didProfileFetched(user: user)
    }
    func didUsersFetched(users: [User]) {
        self.delegate?.didUsersFetched(users: users)
    }
    func didAdminUpdated(message: String) {
        self.delegate?.didAdminUpdated(message: message)
    }
    func didUserDeleted(message: String) {
        self.delegate?.didUserDeleted(message: message)
    }
}
