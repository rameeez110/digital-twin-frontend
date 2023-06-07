//
//  AdminRepository.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit

protocol AdminRepositoryDelegate: class {
    func didFailWithError(error: CustomError)
    func didFetchedInvites(invites: [Invite])
    func didUpdatedInvite(invite: String)
    func didFetchedClients(clients: [Invite])
    func didFetchedComments(comments: [Comment])
    func didCommentDeleted()
}

protocol AdminRepositoryProtocol {
    var delegate: AdminRepositoryDelegate? { get set }
    func getInvites()
    func getClients()
    func acceptInvite(invite: Invite)
    func rejectInvite(invite: Invite)
    func deleteInvite(invite: Invite)
    func getComments(property: Property)
    func deleteComment(comment: Comment)
}

final class AdminRepository: AdminRepositoryProtocol {
    weak var delegate: AdminRepositoryDelegate?
    private let remoteDataSource: AdminRemoteDataStoreProtocol

    init(remoteUserDataSource: AdminRemoteDataStoreProtocol, delegate: AdminRepositoryDelegate? = nil) {
        self.remoteDataSource = remoteUserDataSource
        self.delegate = delegate
    }
    func getInvites() {
        self.remoteDataSource.getReceivedInvites()
    }
    func acceptInvite(invite: Invite) {
        self.remoteDataSource.actionInviteRequest(invite: invite, status: .Accepted)
    }
    func rejectInvite(invite: Invite) {
        self.remoteDataSource.actionInviteRequest(invite: invite, status: .Rejected)
    }
    func deleteInvite(invite: Invite) {
        self.remoteDataSource.actionInviteRequest(invite: invite, status: .Deleted)
    }
    func getClients() {
        self.remoteDataSource.getClients()
    }
    func getComments(property: Property) {
        self.remoteDataSource.getComments(property: property)
    }
    func deleteComment(comment: Comment) {
        self.remoteDataSource.deleteComment(comment: comment)
    }
}

extension AdminRepository: AdminRemoteDataStoreDelegate {
    func didFetchedComments(comments: [Comment]) {
        self.delegate?.didFetchedComments(comments: comments)
    }
    func didFetchedClients(invites: [Invite]) {
        self.delegate?.didFetchedClients(clients: invites)
    }
    func didUpdatedInvite(invite: String) {
        self.delegate?.didUpdatedInvite(invite: invite)
    }
    func didFetchedInvites(invites: [Invite]) {
        self.delegate?.didFetchedInvites(invites: invites)
    }
    func didFailWithError(error: CustomError) {
        
    }
    func didCommentDeleted() {
        self.delegate?.didCommentDeleted()
    }
}
