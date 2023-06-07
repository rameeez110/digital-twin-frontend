//
//  AdminRemoteDataStore.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit

protocol AdminRemoteDataStoreDelegate: class {
    func didFailWithError(error: CustomError)
    func didFetchedInvites(invites: [Invite])
    func didUpdatedInvite(invite: String)
    func didFetchedClients(invites: [Invite])
    func didFetchedComments(comments: [Comment])
    func didCommentDeleted()
}

protocol AdminRemoteDataStoreProtocol {
    var delegate: AdminRemoteDataStoreDelegate? { get set }
    func getReceivedInvites()
    func getClients()
    func actionInviteRequest(invite: Invite, status: InviteStatus)
    func getComments(property: Property)
    func deleteComment(comment: Comment)
}

final class AdminRemoteDataStore: AdminRemoteDataStoreProtocol {
    
    weak var delegate: AdminRemoteDataStoreDelegate?
    
    init(delegate: AdminRemoteDataStoreDelegate? = nil) {
        self.delegate = delegate
    }
    
    func getReceivedInvites() {
        AdminRemoteService.sharedInstance.getInvites{ (response, error) in
            if error == nil{
                if let id = response as? [Invite] {
                    self.delegate?.didFetchedInvites(invites: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func actionInviteRequest(invite: Invite, status: InviteStatus) {
        AdminRemoteService.sharedInstance.updateInvite(invite: invite, status: status) { (response, error) in
            if error == nil{
                if let id = response as? String {
                    self.delegate?.didUpdatedInvite(invite: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getClients() {
        AdminRemoteService.sharedInstance.getClients{ (response, error) in
            if error == nil{
                if let id = response as? [Invite] {
                    self.delegate?.didFetchedClients(invites: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func getComments(property: Property) {
        AdminRemoteService.sharedInstance.getComments(property: property){ (response, error) in
            if error == nil{
                if let id = response as? [Comment] {
                    self.delegate?.didFetchedComments(comments: id)
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
    func deleteComment(comment: Comment) {
        AdminRemoteService.sharedInstance.deleteComment(comment: comment) { (response, error) in
            if error == nil{
                if let id = response as? Bool {
                    print(id)
                    self.delegate?.didCommentDeleted()
                }
            } else {
                self.delegate?.didFailWithError(error: error ?? CustomError.init(errorCode: 0, errorString: "Unknown error"))
            }
        }
    }
}
