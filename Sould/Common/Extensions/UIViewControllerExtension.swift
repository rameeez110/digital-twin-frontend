//
//  UIViewControllerExtension.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import ToastViewSwift

extension UIViewController {

    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(message: String) {
        let toast = Toast.default(image: UIImage(named: "tick")!, imageTint: nil, title: "", subtitle: message, config: .init(autoHide: true, displayTime: TimeInterval(4), animationTime: TimeInterval(0.3), attachTo: nil))
        toast.show(haptic: .success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            toast.close(after: 5) {
                self.dismiss(animated: true)
            }
        }
    }
}
