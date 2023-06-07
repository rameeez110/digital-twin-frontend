//
//  LoginViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 10/08/2022.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButtonStack: UIStackView!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var eyeButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.setLeftPaddingPoints(10.0)
        }
    }
    @IBOutlet weak var passTextField: UITextField!{
        didSet{
            passTextField.isSecureTextEntry = true
            passTextField.setLeftPaddingPoints(10.0)
        }
    }
    @IBOutlet weak var rememberMeImgView: UIImageView!
    @IBOutlet weak var rememberMeBtn: UIButton!
    
    
    var viewModel: LoginViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupTextFields()
        self.setUpSignInAppleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
}

//MARK: - IBActions
extension LoginViewController{
    @IBAction func didTapEye() {
        self.eyeButton.isSelected = !self.eyeButton.isSelected
        self.passTextField.isSecureTextEntry = self.eyeButton.isSelected
    }
    
    @IBAction func didTapForgetPass(){
        self.viewModel?.didTapForgetPassword()
    }
    
    @IBAction func didTapLogin(){
        SVProgressHUD.show()
        self.viewModel?.didTapLogin(email: self.emailTextField.text ?? "", password: self.passTextField.text ?? "")
    }
    
    @IBAction func didTapCreateAccount(){
        self.viewModel?.didTapRegister()
    }
    @IBAction func didTapGoogle() {
        let signInConfig = GIDConfiguration(clientID: "349642119478-tu8u7t0n7s2t5pla3ni81064fjrq1vu2.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            // If sign in succeeded, display the app's main content View.
            
            if let googleUser = user {
                self.viewModel?.googleLogin(token: googleUser.authentication.idToken ?? "")
            }
        }
    }
}

//MARK: - Functions
extension LoginViewController{
    func setupUI() {
        self.infoLabel.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.eyeButton.isSelected = true
        self.passTextField.isSecureTextEntry = self.eyeButton.isSelected
    }
    func setupTextFields(){
        passTextField.placeholder = "Password"
        let imageView =  UIImageView(image: UIImage(named: "lock"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -8, y: 5, width: 16, height: 16)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightView.addSubview(imageView)
        passTextField.rightView = rightView
        passTextField.rightViewMode = .always
        
        emailTextField.placeholder = "Email"
        let emailimageView =  UIImageView(image: UIImage(named: "email"))
        emailimageView.contentMode = .scaleAspectFit
        emailimageView.frame = CGRect(x: -8, y: 5, width: 16, height: 16)
        let emailrightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        emailrightView.addSubview(emailimageView)
        emailTextField.rightView = emailrightView
        emailTextField.rightViewMode = .always
    }
    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.layer.cornerRadius = 20
        authorizationButton.clipsToBounds = true
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        authorizationButton.heightAnchor.constraint(equalToConstant: 40)
                        ])
        //Add button on some view or stack
        self.signInButtonStack.addArrangedSubview(authorizationButton)
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}
//MARK: - Delegates

extension LoginViewController: LoginViewModelDelegate {
    func alert(with title: String, message: String) {
        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
        SVProgressHUD.dismiss()
        self.infoLabel.isHidden = false
        self.infoLabel.text = error
    }
    func hideInfoLabel() {
        self.infoLabel.isHidden = true
    }
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            if let token = appleIDCredential.identityToken {
                let idtoken = String(data: token, encoding: .utf8)
                print(idtoken)
                self.viewModel?.appleLogin(token: idtoken ?? "")
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
