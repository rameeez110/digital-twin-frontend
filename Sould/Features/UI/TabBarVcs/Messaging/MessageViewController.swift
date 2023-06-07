//
//  MessageViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import BetterSegmentedControl
import SwipeCellKit
import STPopup

class MessageViewController: UIViewController {
    
    @IBOutlet weak var segmentedControlView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MessageViewModelProtocol?
    var popupVC = STPopupController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
//        self.viewModel?.getLikedProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.getLikedProperties()
    }
}

//MARK:- Functions
extension MessageViewController {
    func setupUI() {
        self.registerNibsAndSetupTableView()
        if let user = Session.sharedInstance.user {
            if user.userRole == .Admin || user.userRole == .SuperAdmin {
                self.setupNavBarUI()
            }
        }
        self.setupBetterSC()
    }
    func registerNibsAndSetupTableView(){
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "PropertyLikeTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "propertyLikedCell")
        
        self.tableView.estimatedRowHeight = 58
        
        let dummyViewHeight = CGFloat(0)
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }
    func setupNavBarUI() {
        let clients = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(didTapClients))//UIBarButtonItem(title: "Clients", style: .plain, target: self, action: #selector(didTapClients))
        clients.tintColor = .white
        self.navigationItem.rightBarButtonItem  = clients
    }
    
    func setupBetterSC() {
        var originx = UIScreen.main.bounds.width
        originx = originx - 270.0
        originx = originx/2
        let navigationSegmentedControl = BetterSegmentedControl(
            frame: CGRect(x: originx, y: 0, width: 300.0, height: 35.0),
            segments: LabelSegment.segments(withTitles: ["Liked", "Disliked"],
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
    
    func openCommentsPopup(index: Int) {
        let vc = AddCommentPopupViewController(nibName: "AddCommentPopupViewController", bundle: nil)
        if let property = self.viewModel?.filteredDataSource[index] {
            vc.property = property
        }
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
    
    @objc func didTapClients() {
        self.viewModel?.didTapClients()
    }
}

//MARK: - IBActions
extension MessageViewController{
    // MARK: - Action handlers
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        let type = LikeStatus(rawValue: sender.index) ?? LikeStatus.Liked
        switch type {
        case .Liked:
            self.viewModel?.selectedType = type
            self.viewModel?.updateDataSource()
            self.tableView.reloadData()
        case .Disliked:
            self.viewModel?.selectedType = type
            self.viewModel?.updateDataSource()
            self.tableView.reloadData()
        }
    }
}

//MARK: - Delegates

extension MessageViewController: MessageViewModelDelegate {
    func reloadData() {
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
extension MessageViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "propertyLikedCell", for: indexPath) as! PropertyLikeTableViewCell
        
        if let model = self.viewModel?.filteredDataSource[indexPath.row] {
            cell.bindData(data: model)
        }
        cell.delegate = self
        cell.nameLabel.isHidden = true
        cell.descLabel.isHidden = true
        cell.subnameLabel.isHidden = true
        
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
        
        self.viewModel?.didSelectPropery(index: indexPath.row)
    }
}

extension MessageViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right{
            
            let deleteAction = SwipeAction(style: .destructive, title: nil){ action, indexPath in
                print("delete pressed")
                self.viewModel?.deleteLikedProperty(index: indexPath.row)
            }
            deleteAction.image = UIImage(named: "delete_white")
            deleteAction.backgroundColor = UIColor.red
            
            let archiveAction = SwipeAction(style: .default, title: nil){ action, indexPath in
                print("comments pressed")
                self.openCommentsPopup(index: indexPath.row)
            }
            archiveAction.image = UIImage(named: "communication")
            archiveAction.backgroundColor = CommonClass.sharedInstance.appThemeColor()
            return [deleteAction,archiveAction]
        }
        
        return nil
    }
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
