//
//  SendInvitePopupViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit
import STPopup
import ToastViewSwift
import SVProgressHUD

class SendInvitePopupViewController: UIViewController {
    
    //MARK: - IBoutlets & Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "SendInvitePopupViewController", bundle: nil)
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: 250)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Lifecycle Methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func awakeFromNib() {
        // Initialization code
        
        super.awakeFromNib()
    }
}

extension SendInvitePopupViewController {
    func setupUI() {
        self.infoLabel.isHidden = true
    }
    func validateFields() -> Bool {
        if self.emailTextField.text!.isEmpty{
//            self.showAlert(title: "Alert!", msg: "Email can not be empty.")
            self.showError(error: "Email can not be empty.")
            return false
        } else if !CommonClass.sharedInstance.isValidEmail(self.emailTextField.text!) {
//            self.showAlert(title: "Alert!", msg: "Invalid email address")
            self.showError(error: "Invalid email address")
            return false
        }
        return true
    }
    
    func showError(error: String) {
        self.infoLabel.isHidden = false
        self.infoLabel.text = error
    }
}
 
extension SendInvitePopupViewController {
    @IBAction func didTapCancel() {
        self.dismiss(animated: true)
    }
    @IBAction func didTapSend() {
        self.infoLabel.isHidden = true
        if self.validateFields() {
            SVProgressHUD.show()
            AdminRemoteService.sharedInstance.sendInvite(email: self.emailTextField.text!) { (response, error) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                if error == nil{
                    if let id = response as? String {
                        self.showToast(message: "Invite sent successfully")
                    }
                } else {
                    self.showError(error: error?.errorString ?? "")
                }
            }
        }
    }
}
