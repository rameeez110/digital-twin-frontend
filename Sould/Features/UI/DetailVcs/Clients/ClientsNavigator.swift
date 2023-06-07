//
//  ClientsNavigator.swift
//  Sould
//
//  Created by Rameez Hasan on 04/02/2023.
//

import UIKit

protocol ClientsNavigatorProtocol {
    func goBack()
}


class ClientsNavigator: ClientsNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
