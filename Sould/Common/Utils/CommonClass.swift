//
//  CommonClass.swift
//  Sould
//
//  Created by Rameez Hasan on 12/08/2022.
//

import UIKit

class CommonClass {
    static var sharedInstance = CommonClass()
//    var isMultiTenantApp = false
    var isMultiTenantApp = true
}

extension CommonClass {
    
    func appThemeColor() -> UIColor {
        return UIColor().colorWithHexString(hexString: "94F1F7")
    }
}

extension CommonClass {
    func ios15NavBar(color: UIColor,textColor: UIColor) {
        let attrs = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19)!
        ]
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
    
    func customizeUINavigationBar() {
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 19)!
        ]
        UINavigationBar.appearance().barTintColor = CommonClass.sharedInstance.appThemeColor()
        self.ios15NavBar(color: CommonClass.sharedInstance.appThemeColor(), textColor: .black)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
    }
    
    func customizeUITabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 12)!], for: .selected)
    }
    
    func customizeUISearchBar() {
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Montserrat-Regular", size: 14)!
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Montserrat-Regular", size: 14)!
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
