//
//  UserListingViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 09/02/2023.
//

import UIKit
import SVProgressHUD
import SwipeCellKit

class UserListingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: UserListingViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.viewModel?.getAllUsers()
    }
}

//MARK:- Functions
extension UserListingViewController {
    func setupUI() {
        self.registerNibsAndSetupTableView()
    }
    func registerNibsAndSetupTableView(){
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "InvitesTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "invitesTableCell")
        
        self.tableView.estimatedRowHeight = 58
        
        let dummyViewHeight = CGFloat(0)
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
}

//MARK: - IBActions
extension UserListingViewController{
    // MARK: - Action handlers
}

//MARK: - Delegates

extension UserListingViewController: UserListingViewModelDelegate {
    func updatePropertyUI() {
        
    }
    
    func reloadUsers() {
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
    func showToastView(message: String) {
        SVProgressHUD.dismiss()
        self.showToast(message: message)
    }
}

//MARK: - Table view Delegates
extension UserListingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invitesTableCell", for: indexPath) as! InvitesTableViewCell
        
        cell.delegate = self
        
        if let model = self.viewModel?.filteredDataSource[indexPath.row] {
            cell.bindData(data: model)
            if model.userRole == .Admin || model.userRole == .SuperAdmin {
                cell.makeAdminButton.setTitle("Remove Admin", for: .normal)
            } else {
                cell.makeAdminButton.setTitle("Make Admin", for: .normal)
            }
        }
        
        cell.makeAdminButton.isHidden = false
        cell.makeAdminButton.tag = indexPath.row
        cell.makeAdminButton.addTarget(self, action: #selector(adminButtonTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func adminButtonTapped(sender:UIButton){
        if let model = self.viewModel?.filteredDataSource[sender.tag] {
            SVProgressHUD.show()
            if model.userRole == .Admin || model.userRole == .SuperAdmin {
                self.viewModel?.removeAdmin(model: model)
            } else {
                self.viewModel?.makeAdmin(model: model)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.filteredDataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = self.viewModel?.filteredDataSource[indexPath.row] {
            self.viewModel?.goToViewProfile(model: model)
        }
    }
}

extension UserListingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchTerm = searchBar.text ?? ""
        self.viewModel?.updateDataSource()
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension UserListingViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right{
            
            let deleteAction = SwipeAction(style: .destructive, title: nil){ action, indexPath in
                print("delete pressed")
                self.viewModel?.deleteOtherUser(index: indexPath.row)
            }
            deleteAction.image = UIImage(named: "delete_white")
            deleteAction.backgroundColor = UIColor.red
            
            return [deleteAction]
        }
        
        return nil
    }
}
