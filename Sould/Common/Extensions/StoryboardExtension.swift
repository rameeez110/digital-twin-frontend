//
//  StoryboardExtension.swift
//  Sould
//
//  Created by Rameez Hasan on 12/08/2022.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case main = "Main"
        case tabbar = "TabBar"
        case detail = "DetailVcs"
    }

    // MARK: - Convenience Initializers

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    // MARK: - View Controller Instantiation from Generics

    func initialViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateInitialViewController() as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.self)")
        }

        return viewController
    }

    func instantiateViewController<T: UIViewController>() -> T {
        let identifier = String(describing: T.self).components(separatedBy: ".").last!
        guard  let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(identifier) ")
        }

        return viewController
    }
}
