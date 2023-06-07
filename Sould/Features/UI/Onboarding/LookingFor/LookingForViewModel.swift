//
//  LookingForViewModel.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

enum LookingForScreenType: Int {
    case Looking = 0,Profile
}

protocol LookingForViewModelDelegate: AnyObject {
    func alert(with title: String, message: String)
    func validationError(error: String)
    func hideInfoLabel()
}

// Protocol for view model will use it for wiring
protocol LookingForViewModelProtocol {
    var screenType: LookingForScreenType { get set}
    var delegate: LookingForViewModelDelegate? { get set }
    
    func didTapProfile()
    func didTapLucky()
}

final class LookingForViewModel: LookingForViewModelProtocol {
    var screenType: LookingForScreenType
    weak var delegate: LookingForViewModelDelegate?
    private let navigator: LookingForNavigator
    private let userService: UserServiceProtocol

    init(service: UserServiceProtocol,type: LookingForScreenType,navigator: LookingForNavigator, delegate: LookingForViewModelDelegate? = nil) {
        self.delegate = delegate
        self.navigator = navigator
        self.userService = service
        self.screenType = type
    }

    func didTapProfile() {
        if self.screenType == .Looking {
            if let user = Session.sharedInstance.user {
                self.userService.updateUserType(type: .Visitor)
            }
        } else {
            self.navigator.navigateToFilters()
        }
    }
    
    func didTapLucky() {
        if self.screenType == .Looking {
            if let user = Session.sharedInstance.user {
                self.userService.updateUserType(type: .Dealer)
            }
        } else {
            self.navigator.navigateToHome()
        }
    }
}

extension LookingForViewModel: UserServiceDelegate {
    
    func didFailWithError(error: CustomError) {
        self.delegate?.alert(with: "Alert!", message: error.errorString ?? "")
    }
    func didProfileUpdated() {
        self.navigator.navigateToProfile()
    }
}
