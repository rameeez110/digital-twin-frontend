//
//  AddCommentPopupViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit
import ToastViewSwift
import SVProgressHUD

protocol AddCommentPopupVCDelegate: NSObjectProtocol {
    func didCommentUpdated()
}

class AddCommentPopupViewController: UIViewController {
    
    //MARK: - IBoutlets & Properties
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var property = Property()
    var comment = Comment()
    weak var delegate: AddCommentPopupVCDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AddCommentPopupViewController", bundle: nil)
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: 500)
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

extension AddCommentPopupViewController {
    func setupUI() {
        self.infoLabel.isHidden = true
        self.textView.text = self.comment.comment
    }
    func validateFields() -> Bool {
        if self.textView.text!.isEmpty{
            self.showError(error: "Please add something to comment.")
            return false
        }
        return true
    }
    
    func showError(error: String) {
        self.infoLabel.isHidden = false
        self.infoLabel.text = error
    }
}

extension AddCommentPopupViewController {
    @IBAction func didTapCancel() {
        self.dismiss(animated: true)
    }
    @IBAction func didTapAdd() {
        self.infoLabel.isHidden = true
        if self.validateFields() {
            SVProgressHUD.show()
            self.comment.comment = self.textView.text!
            AdminRemoteService.sharedInstance.createEditComment(comment: self.comment, property: self.property) { (response, error) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                if error == nil{
                    if let id = response as? Bool {
                        print(id)
                        self.delegate?.didCommentUpdated()
                        if self.comment.id == "" {
                            self.showToast(message: "Comment added successfully")
                        } else {
                            self.showToast(message: "Comment updated successfully")
                        }
                    }
                } else {
                    self.showError(error: error?.errorString ?? "")
                }
            }
        }
    }
}
