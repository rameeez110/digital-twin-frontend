//
//  AppNavigationController.swift
//  Sould
//
//  Created by Rameez Hasan on 12/08/2022.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        navigationBar.barTintColor = .black
        navigationBar.tintColor = UIColor.black
        navigationBar.titleTextAttributes = attrs
        navigationBar.titleTextAttributes =
             [NSAttributedString.Key.foregroundColor: UIColor.black,
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        self.ios15NavBar(color: CommonClass.sharedInstance.appThemeColor(), textColor: .black)

//        navigationBar.barTintColor = .black
//        navigationBar.tintColor = .white
//        navigationController?.navigationBar.isTranslucent = false
    }

    private func ios15NavBar(color: UIColor,textColor: UIColor) {
        let attrs = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
    
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            let navigationBar = UINavigationBar()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = attrs
            appearance.backgroundColor = color
            navigationBar.standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
