//
//  UserService.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import Foundation
import UIKit

protocol UserServiceDelegate: class {
    func didFailWithError(error: CustomError)
    func didLoggedIn(user: User)
    func didRegistered(user: User)
    func didPasswordReset(response: String)
    func didProfileUpdated()
    func didImageUploaded(image: Attachment)
    func didProfileFetched(user: User)
    func didUsersFetched(users: [User])
    func didAdminUpdated(message: String)
    func didUserDeleted(message: String)
}

extension UserServiceDelegate {
    func didLoggedIn(user: User) {}
    func didRegistered(user: User) {}
    func didPasswordReset(response: String) {}
    func didProfileUpdated() {}
    func didImageUploaded(image: Attachment) {}
    func didProfileFetched(user: User) {}
    func didUsersFetched(users: [User]) {}
    func didAdminUpdated(message: String) {}
    func didUserDeleted(message: String) {}
}

protocol UserServiceProtocol {
    var delegate: UserServiceDelegate? { get set }
    func loginUser(user: User)
    func registerUser(user: User)
    func forgetPassword(email: String)
    func googleLogin(token: String)
    func appleLogin(token: String)
    func updateProfile(user: User)
    func uploadImage(image:UIImage)
    func updateUserType(type: UserType)
    func getProfile()
    func getAllUsers()
    func removeAdmin(model: User)
    func makeAdmin(model: User)
    func deleteOtherUser(user: User)
    func deleteUser()
}

final class UserService: UserServiceProtocol {

    weak var delegate: UserServiceDelegate?
    private let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    func loginUser(user: User) {
        self.userRepository.loginUser(user: user)
    }
    func registerUser(user: User) {
        self.userRepository.registerUser(user: user)
    }
    func forgetPassword(email: String) {
        self.userRepository.forgetPassword(email: email)
    }
    func googleLogin(token: String) {
        self.userRepository.googleLogin(token: token)
    }
    func appleLogin(token: String) {
        self.userRepository.appleLogin(token: token)
    }
    func updateProfile(user: User) {
        self.userRepository.updateProfile(user: user)
    }
    func uploadImage(image: UIImage) {
        self.userRepository.uploadImage(image: image)
    }
    func updateUserType(type: UserType) {
        self.userRepository.updateUserType(type: type)
    }
    func getProfile() {
        self.userRepository.getProfile()
    }
    func getAllUsers() {
        self.userRepository.getAllUsers()
    }
    func removeAdmin(model: User) {
        self.userRepository.removeAdmin(model: model)
    }
    func makeAdmin(model: User) {
        self.userRepository.makeAdmin(model: model)
    }
    func deleteOtherUser(user: User) {
        self.userRepository.deleteOtherUser(user: user)
    }
    func deleteUser() {
        self.userRepository.deleteUser()
    }
}

extension UserService: UserRepositoryDelegate {
    func didFailWithError(error: CustomError) {
        self.delegate?.didFailWithError(error: error)
    }
    func didLoggedIn(user: User) {
        self.delegate?.didLoggedIn(user: user)
    }
    func didRegistered(user: User) {
        self.delegate?.didRegistered(user: user)
    }
    func didForgetPassword(response: String) {
        self.delegate?.didPasswordReset(response: response)
    }
    func profileUpdated(user: User) {
        self.delegate?.didProfileUpdated()
    }
    func imageUploaded(image: Attachment) {
        self.delegate?.didImageUploaded(image: image)
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
