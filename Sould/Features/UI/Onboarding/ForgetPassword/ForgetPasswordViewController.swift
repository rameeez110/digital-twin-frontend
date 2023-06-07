//
//  ForgetPasswordViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit
import SVProgressHUD

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.setLeftPaddingPoints(10.0)
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var viewModel: ForgetPasswordViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupTextFields()
    }

}

//MARK: - Methods
extension ForgetPasswordViewController {
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Forgot Password"
    }
    func setupTextFields(){
        emailTextField.placeholder = "Email"
        let emailimageView =  UIImageView(image: UIImage(named: "email"))
        emailimageView.contentMode = .scaleAspectFit
        emailimageView.frame = CGRect(x: -8, y: 5, width: 16, height: 16)
        let emailrightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        emailrightView.addSubview(emailimageView)
        emailTextField.rightView = emailrightView
        emailTextField.rightViewMode = .always
    }
}

//MARK: - IBActions
extension ForgetPasswordViewController{
    @IBAction func didTapBack(){
        self.viewModel?.didTapBack()
    }
    
    @IBAction func didTapReset(){
        SVProgressHUD.show()
        self.viewModel?.didTapSubmit(email: self.emailTextField.text!)
    }
}

//MARK: - Delegates

extension ForgetPasswordViewController: ForgetPasswordViewModelDelegate {
    func alert(with title: String, message: String) {
        SVProgressHUD.dismiss()
        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
        SVProgressHUD.dismiss()
//        self.setupInfo(status: false)
//        self.infoLabel.text = error
    }
    func hideInfoLabel() {
//        self.setupInfo(status: true)
    }
    func showAlert(response: String) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "", message: response,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            self.viewModel?.didTapBack()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
