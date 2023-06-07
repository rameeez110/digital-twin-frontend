//
//  InvitesViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 12/01/2023.
//

import UIKit
import BetterSegmentedControl
import SwipeCellKit
import SVProgressHUD

protocol InvitesVCDelegate: class {
    func didInvitesUpdated(invites: [Invite])
}

class InvitesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControlView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: InvitesViewModelProtocol?
    weak var delegate: InvitesVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.getInvites()
    }
}

//MARK:- Functions
extension InvitesViewController {
    func setupUI() {
        self.registerNibsAndSetupTableView()
//        self.setupBetterSC()
    }
    func registerNibsAndSetupTableView(){
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "InvitesTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "invitesTableCell")
        
        self.tableView.estimatedRowHeight = 58
        
        let dummyViewHeight = CGFloat(0)
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    func setupBetterSC() {
        var originx = UIScreen.main.bounds.width
        originx = originx - 270.0
        originx = originx/2
        let navigationSegmentedControl = BetterSegmentedControl(
            frame: CGRect(x: originx, y: 0, width: 300.0, height: 35.0),
            segments: LabelSegment.segments(withTitles: ["Accepted", "Pending"],
                                            normalTextColor: .black,
                                            selectedTextColor: .black),
            options:[.backgroundColor(CommonClass.sharedInstance.appThemeColor()),
                     .indicatorViewBackgroundColor(UIColor.white),
                     .cornerRadius(15.0),
                     .animationSpringDamping(1.0)])
        navigationSegmentedControl.addTarget(self,
                                             action:      #selector(self.navigationSegmentedControlValueChanged(_:)),
                                             for: .valueChanged)
        self.segmentedControlView.addSubview(navigationSegmentedControl)
    }
}

//MARK: - IBActions
extension InvitesViewController{
    // MARK: - Action handlers
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        let type = InviteStatus(rawValue: sender.index) ?? InviteStatus.Accepted
        switch type {
        case .Accepted:
            self.viewModel?.selectedType = type
            self.viewModel?.updateDataSource()
            self.tableView.reloadData()
        case .Rejected:
            self.viewModel?.selectedType = type
            self.viewModel?.updateDataSource()
            self.tableView.reloadData()
        case .Pending:
            self.viewModel?.selectedType = type
            self.viewModel?.updateDataSource()
            self.tableView.reloadData()
        case .Deleted:
            self.viewModel?.selectedType = type
            self.viewModel?.updateDataSource()
            self.tableView.reloadData()
        }
    }
}

//MARK: - Delegates

extension InvitesViewController: InvitesViewModelDelegate {
    func reloadInvites() {
        SVProgressHUD.dismiss()
        if let invitesPending = self.viewModel?.dataSource.filter({$0.status == false}) {
            self.delegate?.didInvitesUpdated(invites: invitesPending)
        }
        self.tableView.reloadData()
    }
    
    func alert(with title: String, message: String) {
//        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func hideInfoLabel() {
//        self.setupInfo(status: true)
    }
    func showToastView(message: String) {
        self.showToast(message: message)
    }
}

//MARK: - Table view Delegates
extension InvitesViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invitesTableCell", for: indexPath) as! InvitesTableViewCell
        
        if let model = self.viewModel?.filteredDataSource[indexPath.row] {
            cell.bindData(data: model)
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.filteredDataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        self.viewModel?.didSelectPropery(index: indexPath.row)
    }
}

extension InvitesViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right{
            
            let rejectedAction = SwipeAction(style: .destructive, title: nil){ action, indexPath in
                DispatchQueue.main.async {
                    SVProgressHUD.show()
                }
                self.viewModel?.rejectInvite(invite: self.viewModel?.filteredDataSource[indexPath.row] ?? Invite())
            }
            rejectedAction.image = UIImage(named: "close")
            rejectedAction.backgroundColor = UIColor.orange
            
            let acceptedAction = SwipeAction(style: .default, title: nil){ action, indexPath in
                DispatchQueue.main.async {
                    SVProgressHUD.show()
                }
                self.viewModel?.acceptInvite(invite: self.viewModel?.filteredDataSource[indexPath.row] ?? Invite())
            }
            acceptedAction.image = UIImage(named: "tick")
            acceptedAction.backgroundColor = CommonClass.sharedInstance.appThemeColor()
            
            let deletedAction = SwipeAction(style: .default, title: nil){ action, indexPath in
                DispatchQueue.main.async {
                    SVProgressHUD.show()
                }
                self.viewModel?.deleteInvite(invite: self.viewModel?.filteredDataSource[indexPath.row] ?? Invite())
            }
            
            deletedAction.image = UIImage(named: "delete_white")
            deletedAction.backgroundColor = UIColor.red
            if let model = self.viewModel?.filteredDataSource[indexPath.row] {
                if model.status {
                    return [deletedAction]
                } else {
                    return [deletedAction,rejectedAction,acceptedAction]
                }
            } else {
                return [deletedAction]
            }
        }
        
        return nil
    }
}
