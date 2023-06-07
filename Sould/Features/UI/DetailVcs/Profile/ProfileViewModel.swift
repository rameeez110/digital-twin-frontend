//
//  ProfileViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 16/08/2022.
//

import UIKit

struct ProfileViewModelDataSource {
    var title = String()
    var text = String()
}

protocol ProfileViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func hideLoader()
    func reloadTableData()
    func showLoginScreen()
}

// Protocol for view model will use it for wiring
protocol ProfileViewModelProtocol {
    var delegate: ProfileViewModelDelegate? { get set }
    var dataSource: [ProfileViewModelDataSource] {get set}
    var invites: [Invite] {get set}
    var viewMode: Bool {get set}
    var viewUser: User {get set}
    
    func getProfile()
    func mapDataSource()
    func didTapDone()
    func uploadImage(image:UIImage)
    func didTapInvites()
    func showUsersVc()
    func deleteUser()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    weak var delegate: ProfileViewModelDelegate?
    private let navigator: ProfileNavigator
    private let userService: UserServiceProtocol
    var dataSource: [ProfileViewModelDataSource]
    var titles: [String]
    var invites: [Invite]
    var viewMode: Bool
    var viewUser: User
    
    init(service: UserServiceProtocol,navigator: ProfileNavigator,invites: [Invite],mode: Bool, delegate: ProfileViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
        self.dataSource = [ProfileViewModelDataSource]()
        self.titles = ["First Name","Last Name","Email","Phone Number","Invite Client","See Invites","See Users","Logout","Delete Account"]
        self.invites = invites
        self.viewMode = mode
        self.viewUser = User()
    }

    func mapDataSource() {
        self.dataSource = [ProfileViewModelDataSource]()
        let user = Session.sharedInstance.user ?? User()
        for i in 0..<self.titles.count {
            var model = ProfileViewModelDataSource()
            model.title = self.titles[i]
            if self.viewMode {
                if i == 0 {
                    model.text = self.viewUser.firstName
                } else if i == 1 {
                    model.text = self.viewUser.lastName
                } else if i == 2 {
                    model.text = self.viewUser.email
                } else if i == 3 {
                    model.text = self.viewUser.phone
                }
                if i < 4 {
                    self.dataSource.append(model)
                }
            } else {
                if i == 0 {
                    model.text = Session.sharedInstance.user?.firstName ?? ""
                } else if i == 1 {
                    model.text = Session.sharedInstance.user?.lastName ?? ""
                } else if i == 2 {
                    model.text = Session.sharedInstance.user?.email ?? ""
                } else if i == 3 {
                    model.text = Session.sharedInstance.user?.phone ?? ""
                }
                if i == 6 {
                    if user.userRole == .SuperAdmin {
                        self.dataSource.append(model)
                    }
                } else if i == 4 {
                    if user.userRole == .Admin || user.userRole == .SuperAdmin {
                        self.dataSource.append(model)
                    }
                } else {
                    self.dataSource.append(model)
                }
            }
        }
    }
    func didTapDone() {
        let user = User()
        user.firstName = self.dataSource[0].text
        user.lastName = self.dataSource[1].text
        user.phone = self.dataSource[3].text
        self.userService.updateProfile(user: user)
    }
    func uploadImage(image: UIImage) {
        self.userService.uploadImage(image:image)
    }
    func getProfile() {
        self.userService.getProfile()
    }
    
    func didTapInvites() {
        self.navigator.goToInvites(ref: self)
    }
    
    func showUsersVc() {
        self.navigator.goToUserListing()
    }
    func deleteUser() {
        self.userService.deleteUser()
    }
}

extension ProfileViewModel: InvitesVCDelegate {
    func didInvitesUpdated(invites: [Invite]) {
        self.invites = invites
    }
}

extension ProfileViewModel: UserServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didProfileUpdated() {
        self.delegate?.hideLoader()
        self.navigator.goBack()
    }
    func didProfileFetched(user: User) {
        self.mapDataSource()
        self.delegate?.reloadTableData()
    }
    func didImageUploaded(image: Attachment) {
        let user = User()
        user.firstName = self.dataSource[0].text
        user.lastName = self.dataSource[1].text
        user.phone = self.dataSource[3].text
        user.image = image.link
        self.userService.updateProfile(user: user)
    }
    func didUserDeleted(message: String) {
        self.delegate?.showLoginScreen()
    }
}
