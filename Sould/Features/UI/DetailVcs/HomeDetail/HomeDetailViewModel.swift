//
//  HomeDetailViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 04/02/2023.
//

import UIKit

protocol HomeDetailViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
    func reloadComments()
}

// Protocol for view model will use it for wiring
protocol HomeDetailViewModelProtocol {
    var delegate: HomeDetailViewModelDelegate? { get set }
    var dataSource: [Comment] {get set}
    var data: Property {get set}
    
    func getComments(property: Property)
    func deleteComment(comment: Comment)
}

final class HomeDetailViewModel: HomeDetailViewModelProtocol {
    
    weak var delegate: HomeDetailViewModelDelegate?
    private let navigator: MessageNavigator
    private let adminService: AdminServiceProtocol
    var dataSource: [Comment]
    var data: Property

    init(service: AdminServiceProtocol,navigator: MessageNavigator, delegate: HomeDetailViewModelDelegate? = nil,property: Property) {
        self.delegate = delegate
        self.navigator = navigator
        self.adminService = service
        self.dataSource = [Comment]()
        self.data = property
    }
    func getComments(property: Property) {
        self.adminService.getComments(property: property)
    }
    func deleteComment(comment: Comment) {
        self.adminService.deleteComment(comment: comment)
    }
}

extension HomeDetailViewModel: AdminServiceDelegate {
    func didFailWithError(error: CustomError) {
        
    }
    func didFetchedComments(comments: [Comment]) {
        self.dataSource = comments
        self.delegate?.reloadComments()
    }
    func didCommentDeleted() {
        self.getComments(property: self.data)
    }
}
