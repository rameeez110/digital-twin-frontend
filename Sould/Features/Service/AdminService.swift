//
//  AdminService.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import Foundation

protocol AdminServiceDelegate: class {
    func didFailWithError(error: CustomError)
    func didFetchedInvites(invites: [Invite])
    func didUpdatedInvite(invite: String)
    func didFetchedClients(clients: [Invite])
    func didFetchedComments(comments: [Comment])
    func didCommentDeleted()
}

extension AdminServiceDelegate {
    func didFetchedInvites(invites: [Invite]) {}
    func didUpdatedInvite(invite: String) {}
    func didFetchedClients(clients: [Invite]) {}
    func didFetchedComments(comments: [Comment]) {}
    func didCommentDeleted() {}
}

protocol AdminServiceProtocol {
    var delegate: AdminServiceDelegate? { get set }
    func getInvites()
    func getClients()
    func acceptInvite(invite: Invite)
    func rejectInvite(invite: Invite)
    func deleteInvite(invite: Invite)
    func getComments(property: Property)
    func deleteComment(comment: Comment)
}

final class AdminService: AdminServiceProtocol {
    
    weak var delegate: AdminServiceDelegate?
    private let adminRepository: AdminRepositoryProtocol

    init(adminRepository: AdminRepositoryProtocol) {
        self.adminRepository = adminRepository
    }
    func getInvites() {
        self.adminRepository.getInvites()
    }
    func getClients() {
        self.adminRepository.getClients()
    }
    func acceptInvite(invite: Invite) {
        self.adminRepository.acceptInvite(invite: invite)
    }
    func rejectInvite(invite: Invite) {
        self.adminRepository.rejectInvite(invite: invite)
    }
    func deleteInvite(invite: Invite) {
        self.adminRepository.deleteInvite(invite: invite)
    }
    func getComments(property: Property) {
        self.adminRepository.getComments(property: property)
    }
    func deleteComment(comment: Comment) {
        self.adminRepository.deleteComment(comment: comment)
    }
}

extension AdminService: AdminRepositoryDelegate {
    func didFetchedClients(clients: [Invite]) {
        self.delegate?.didFetchedClients(clients: clients)
    }
    
    func didFetchedInvites(invites: [Invite]) {
        self.delegate?.didFetchedInvites(invites: invites)
    }
    
    func didFailWithError(error: CustomError) {
        self.delegate?.didFailWithError(error: error)
    }
    func didUpdatedInvite(invite: String) {
        self.delegate?.didUpdatedInvite(invite: invite)
    }
    func didFetchedComments(comments: [Comment]) {
        self.delegate?.didFetchedComments(comments: comments)
    }
    func didCommentDeleted() {
        self.delegate?.didCommentDeleted()
    }
}
