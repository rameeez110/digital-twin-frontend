//
//  ClientsViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit

class ClientsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ClientsViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupNavBarUI()
        self.viewModel?.getClients()
    }
}

//MARK:- Functions
extension ClientsViewController {
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
    func setupNavBarUI() {
        let clients = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(didTapClients))
        self.navigationItem.rightBarButtonItem  = clients
    }
    @objc func didTapClients() {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isClientSelected)
        UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.selectedClientId)
        UserDefaults.standard.synchronize()
        self.viewModel?.goBack()
    }
}

//MARK: - IBActions
extension ClientsViewController{
    // MARK: - Action handlers
}

//MARK: - Delegates

extension ClientsViewController: ClientsViewModelDelegate {
    func updatePropertyUI() {
        
    }
    
    func reloadClients() {
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
}

//MARK: - Table view Delegates
extension ClientsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invitesTableCell", for: indexPath) as! InvitesTableViewCell
        
        if let model = self.viewModel?.dataSource[indexPath.row] {
            cell.bindData(data: model.toUser)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = self.viewModel?.dataSource[indexPath.row] {
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isClientSelected)
            UserDefaults.standard.set(model.toUser.userId, forKey: Constants.UserDefaultsKey.selectedClientId)
            UserDefaults.standard.synchronize()
            self.viewModel?.goBack()
        }
    }
}
