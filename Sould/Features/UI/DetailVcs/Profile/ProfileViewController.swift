//
//  ProfileViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 16/08/2022.
//

import UIKit
import SVProgressHUD
import SDWebImage
import STPopup

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var viewModel: ProfileViewModelProtocol?
    var profilePicUpdated = false
    var popupVC = STPopupController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.viewModel?.mapDataSource()
        self.viewModel?.getProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
}

//MARK:- Functions
extension ProfileViewController {
    func setupUI() {
        if self.viewModel?.viewMode ?? false {
            if let url = URL(string: self.viewModel?.viewUser.image ?? "") {
                self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_new"))
            }
        } else {
            if let url = URL(string: Session.sharedInstance.user?.image ?? "") {
                self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_new"))
            }
        }
        self.registerNibsAndSetupTableView()
        if !(self.viewModel?.viewMode ?? false) {
            let button1 = UIBarButtonItem(image: UIImage(named: "tick"), style: .plain, target: self, action: #selector(didTapDone))
            self.navigationItem.rightBarButtonItem  = button1
        }
        
    }
    func registerNibsAndSetupTableView(){
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "ProfileTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "profileTableCell")
        
        self.tableView.estimatedRowHeight = 58
        
        let dummyViewHeight = CGFloat(0)
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    func openPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true) {
            }
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true) {
            }
        }
    }
    func initializePopup(viewController: UIViewController,_ style: STPopupStyle = .formSheet){
        popupVC = STPopupController.init(rootViewController: viewController)
        popupVC.containerView.backgroundColor = UIColor.clear
        let blur = UIBlurEffect.init(style: .dark)
        popupVC.style = style
        popupVC.backgroundView = UIVisualEffectView.init(effect: blur)
        popupVC.backgroundView?.alpha = 0.9
        popupVC.setNavigationBarHidden(true, animated: true)
        popupVC.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        popupVC.present(in: self)
    }
    // function which is triggered when handleTap is called
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        popupVC.dismiss()
    }
}

//MARK: - IBActions
extension ProfileViewController{
    @objc func didTapDone() {
        SVProgressHUD.show()
        if self.profilePicUpdated {
            self.viewModel?.uploadImage(image: self.profileImageView.image!)
        } else {
            self.viewModel?.didTapDone()
        }
    }
    @IBAction func didTapImageCross() {
        self.profileImageView.image = UIImage(named: "user_new")
        self.profilePicUpdated = true
    }
    @IBAction func didTapChangeImage() {
        let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
            //Cancel Action
        }))
        
        
        sheet.addAction(UIAlertAction(title: "Delete Photo",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            self.didTapImageCross()
        }))
        sheet.addAction(UIAlertAction(title: "Take Photo",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            self.openCamera()
        }))
        sheet.addAction(UIAlertAction(title: "Choose Photo",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            self.openPhotoGallery()
        }))
        self.present(sheet, animated: true, completion: nil)
    }
}

//MARK: - Delegates

extension ProfileViewController: ProfileViewModelDelegate {
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
    func alert(with title: String, message: String) {
        SVProgressHUD.dismiss()
//        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
    }
    func hideInfoLabel() {
//        self.setupInfo(status: true)
    }
    func reloadTableData() {
        self.tableView.reloadData()
    }
    func showLoginScreen() {
        if let user = Session.sharedInstance.user {
            user.removeUser()
        }
        if let mySceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            mySceneDelegate.navigator.installRoot(into: mySceneDelegate.window!)
        }
    }
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableCell", for: indexPath) as! ProfileTableViewCell
        cell.setIndexPath(indexPath: indexPath)
        cell.delegate = self
        if indexPath.row == 2 {
            cell.titleTextField.isUserInteractionEnabled = false
        } else {
            cell.titleTextField.isUserInteractionEnabled = true
        }
        if let model = self.viewModel?.dataSource[indexPath.row] {
            cell.bindData(model: model)
            if model.title == "See Invites" {
                if let count = self.viewModel?.invites.count, count > 0 {
                    cell.titleLabel.text = "\(model.title) (\(count))"
                }
            }
        }
        
        if indexPath.row > 3 {
            cell.titleTextField.isHidden = true
        } else {
            cell.titleTextField.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == (self.viewModel?.dataSource.count ?? 0) - 1 {
            self.viewModel?.deleteUser()
        } else if indexPath.row == (self.viewModel?.dataSource.count ?? 0) - 2 {
            if let user = Session.sharedInstance.user {
                user.removeUser()
            }
            if let mySceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                mySceneDelegate.navigator.installRoot(into: mySceneDelegate.window!)
            }
        }
        
        if let user = Session.sharedInstance.user {
            switch user.userRole {
            case .SuperAdmin:
                if indexPath.row == 4 {
                    self.openInvitePopup()
                } else if indexPath.row == 5 {
                    self.viewModel?.didTapInvites()
                } else if indexPath.row == 6 {
                    self.viewModel?.showUsersVc()
                }
            case .Admin:
                if indexPath.row == 4 {
                    self.openInvitePopup()
                } else if indexPath.row == 5 {
                    self.viewModel?.didTapInvites()
                }
            case .User:
                if indexPath.row == 4 {
                    self.viewModel?.didTapInvites()
                }
            }
        }
    }
    
    func openInvitePopup() {
        let vc = SendInvitePopupViewController(nibName: "SendInvitePopupViewController", bundle: nil)
        self.initializePopup(viewController: vc)
    }
}

extension ProfileViewController: EditProfileCellDelegate{
    func didEndEditing(indexPath: IndexPath,textField: UITextField) {
        let text = textField.text ??  ""
        
        self.viewModel?.dataSource[indexPath.row].text = text
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = image
            self.profilePicUpdated = true
        }
        self.dismiss(animated: true) {
        }
    }
}
