//
//  HomeDetailViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import STPopup

class HomeDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = Property()
    var viewModel: HomeDetailViewModelProtocol?
    var popupVC = STPopupController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupNavBarUI()
        self.viewModel?.getComments(property: self.data)
    }

}

extension HomeDetailViewController {
    func setupUI() {
        self.registerNibsAndSetupTableView()
    }
    func registerNibsAndSetupTableView(){
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "HomeDetailTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "homeDetailTableCell")
        let homeMapCell = UINib(nibName: "HomeMapTableViewCell", bundle:nil)
        self.tableView.register(homeMapCell, forCellReuseIdentifier: "homeMapCell")
        let homeDescCell = UINib(nibName: "HomeDescriptionTableViewCell", bundle:nil)
        self.tableView.register(homeDescCell, forCellReuseIdentifier: "homeDescCell")
        let commentsCell = UINib(nibName: "CommentsTableViewCell", bundle:nil)
        self.tableView.register(commentsCell, forCellReuseIdentifier: "commentsCell")
        
        self.tableView.estimatedRowHeight = 58
        
        let dummyViewHeight = CGFloat(0)
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    func setupNavBarUI() {
        let clients = UIBarButtonItem(image: UIImage(named: "comment"), style: .plain, target: self, action: #selector(didTapComment))
        clients.tintColor = .white
        self.navigationItem.rightBarButtonItem  = clients
    }
    @objc func didTapComment() {
        self.openCommentsPopup(comment: Comment())
    }
}

//MARK: - Delegates

extension HomeDetailViewController: HomeDetailViewModelDelegate {
    func updatePropertyUI() {
        
    }
    
    func reloadComments() {
        self.tableView.reloadData()
    }
    
    func alert(with title: String, message: String) {
//        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
//        self.setupInfo(status: false)
//        self.infoLabel.text = error
    }
    func hideInfoLabel() {
//        self.setupInfo(status: true)
    }
    func openCommentsPopup(comment: Comment) {
        let vc = AddCommentPopupViewController(nibName: "AddCommentPopupViewController", bundle: nil)
        vc.property = self.data
        vc.comment = comment
        vc.delegate = self
        self.initializePopup(viewController: vc)
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

// MARK:- Delegates

extension HomeDetailViewController: AddCommentPopupVCDelegate {
    func didCommentUpdated() {
        self.viewModel?.getComments(property: self.data)
    }
}

extension HomeDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeDetailTableCell", for: indexPath) as! HomeDetailTableViewCell
                
                cell.data = self.data
                cell.bathroomStackView.isHidden = false
                cell.bedroomStackView.isHidden = false
                //            cell.priceLabel.text = "$ \(data.price)"
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let minNumber = numberFormatter.string(from: NSNumber(value:data.price))
                cell.priceLabel.text = "$ \(minNumber ?? "")"
                cell.bathroomCountLabel.text = data.buildingData.bathroomTotal
                if data.buildingData.bathroomTotal == "0" {
                    cell.bathroomStackView.isHidden = true
                }
                if data.buildingData.bedroomsTotal == "0" {
                    cell.bedroomStackView.isHidden = true
                }
                cell.bedroomCountLabel.text = data.buildingData.bedroomsTotal
                cell.streetLabel.text = data.listingId
                cell.nameLabel.text = data.addressData.city
                cell.subNameLabel.text = data.addressData.communityName
                
                
                return cell
            } else {//if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeMapCell", for: indexPath) as! HomeMapTableViewCell
                
                cell.mapView.isHidden = false
                cell.bindData(data: self.data)
                
                return cell
            }
        } else {
            if let dataSource = self.viewModel?.dataSource, dataSource.count > 0 {
                if indexPath.row == dataSource.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeDescCell", for: indexPath) as! HomeDescriptionTableViewCell
                    
                    cell.data = self.data
                    cell.bindData(data: self.data)
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsTableViewCell
                    
                    cell.editButton.tag = indexPath.row
                    cell.editButton.addTarget(self, action: #selector(editTapped(sender:)), for: .touchUpInside)
                    
                    cell.deleteButton.tag = indexPath.row
                    cell.deleteButton.addTarget(self, action: #selector(deleteTapped(sender:)), for: .touchUpInside)
                    
                    let model = dataSource[indexPath.row]
                    if indexPath.row == 0 {
                        cell.titleLabel.isHidden = false
                    } else {
                        cell.titleLabel.isHidden = true
                    }
                    if !model.user.firstName.isEmpty && !model.user.lastName.isEmpty {
                        cell.commentLabel.text = "\(model.user.firstName) \(model.user.lastName): \(model.comment)"
                    } else if !model.user.firstName.isEmpty {
                        cell.commentLabel.text = "\(model.user.firstName): \(model.comment)"
                    } else {
                        cell.commentLabel.text = model.comment
                    }
                    
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeDescCell", for: indexPath) as! HomeDescriptionTableViewCell
                
                cell.data = self.data
                cell.bindData(data: self.data)
                
                return cell
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            if let dataSource = self.viewModel?.dataSource, dataSource.count > 0 {
                return dataSource.count + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 310
            } else {
                return UITableView.automaticDimension
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    
    @objc func editTapped(sender:UIButton){
        if let model = self.viewModel?.dataSource {
            self.openCommentsPopup(comment: model[sender.tag])
        }
    }
    @objc func deleteTapped(sender:UIButton){
        if let model = self.viewModel?.dataSource {
            let alert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete comment?",         preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                //Ok Action
                self.viewModel?.deleteComment(comment: model[sender.tag])
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
