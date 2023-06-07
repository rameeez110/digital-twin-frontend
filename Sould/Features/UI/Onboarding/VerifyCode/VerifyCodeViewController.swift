//
//  VerifyCodeViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

class VerifyCodeViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!{
        didSet{
            codeTextField.setLeftPaddingPoints(10.0)
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var viewModel: VerifyCodeViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupTextFields()
    }

}

//MARK: - Methods
extension VerifyCodeViewController {
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Verify Code"
    }
    func setupTextFields(){
        codeTextField.placeholder = "Code"
        let emailimageView =  UIImageView(image: UIImage(named: "email"))
        emailimageView.contentMode = .scaleAspectFit
        emailimageView.frame = CGRect(x: -8, y: 5, width: 16, height: 16)
        let emailrightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        emailrightView.addSubview(emailimageView)
        codeTextField.rightView = emailrightView
        codeTextField.rightViewMode = .always
    }
}

//MARK: - IBActions
extension VerifyCodeViewController{
    @IBAction func didTapBack(){
        self.viewModel?.didTapBack()
    }
    
    @IBAction func didTapVerify(){
        self.viewModel?.didTapSubmit(code: self.codeTextField.text!)
    }
}

//MARK: - Delegates

extension VerifyCodeViewController: VerifyCodeViewModelDelegate {
    func alert(with title: String, message: String) {
        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
//        self.setupInfo(status: false)
//        self.infoLabel.text = error
    }
    func hideInfoLabel() {
//        self.setupInfo(status: true)
    }
    
}
