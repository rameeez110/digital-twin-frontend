//
//  RegisterViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 10/08/2022.
//

import UIKit
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var eyeConfirmButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            emailTextField.setLeftPaddingPoints(10.0)
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField!{
        didSet{
            emailTextField.setLeftPaddingPoints(10.0)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.setLeftPaddingPoints(10.0)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.isSecureTextEntry = true
            passwordTextField.setLeftPaddingPoints(10.0)
        }
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField!{
        didSet{
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.setLeftPaddingPoints(10.0)
        }
    }
    
    var viewModel: RegisterViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        // Do any additional setup after loading the view.
    }

}

//MARK: - IBActions
extension RegisterViewController{
    @IBAction func didTapEye() {
        self.eyeButton.isSelected = !self.eyeButton.isSelected
        self.passwordTextField.isSecureTextEntry = self.eyeButton.isSelected
    }
    @IBAction func didTapConfirmEye() {
        self.eyeConfirmButton.isSelected = !self.eyeConfirmButton.isSelected
        self.confirmPasswordTextField.isSecureTextEntry = self.eyeConfirmButton.isSelected
    }
    
    @IBAction func didTapSignup(){
        SVProgressHUD.show()
        self.viewModel?.didTapSignup(fName: self.nameTextField.text ?? "", lName: self.lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: self.passwordTextField.text ?? "" , confirmPassword: confirmPasswordTextField.text ?? "")
    }
    
    @IBAction func goBackToLogin(){
        self.viewModel?.didTapGoBack()
    }
}

//MARK: - Functions
extension RegisterViewController{
    func setupTextFields(){
        self.passwordTextField.placeholder = "Password"
        let imageView =  UIImageView(image: UIImage(named: "lock"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -8, y: 5, width: 16, height: 16)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightView.addSubview(imageView)
        self.passwordTextField.rightView = rightView
        self.passwordTextField.rightViewMode = .always
        
        self.confirmPasswordTextField.placeholder = "Repeat Password"
        let confirmpassImageView =  UIImageView(image: UIImage(named: "lock"))
        confirmpassImageView.contentMode = .scaleAspectFit
        confirmpassImageView.frame = CGRect(x: -8, y: 5, width: 16, height: 16)
        let confirmpassrightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        confirmpassrightView.addSubview(confirmpassImageView)
        self.confirmPasswordTextField.rightView = confirmpassrightView
        self.confirmPasswordTextField.rightViewMode = .always
        
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

//MARK: - Delegate
extension RegisterViewController: RegisterViewModelDelegate {
    func alert(with title: String, message: String) {
        SVProgressHUD.dismiss()
        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
//        self.setupInfo(status: false)
        self.infoLabel.isHidden = false
        self.infoLabel.text = error
    }
    func hideInfoLabel() {
        self.infoLabel.isHidden = true
    }
    func showVerifyPopup() {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Registered..", message: "We have sent you an email please go and verify through link you recieved.",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            self.navigationController?.popViewController(animated: true)
//            self.viewModel?.goToLookingFor()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.lastNameTextField.becomeFirstResponder()
        } else if textField == self.lastNameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        return true
    }
}
