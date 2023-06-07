//
//  HomeViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import Koloda
import pop
import SDWebImage
import Onboard

class HomeViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var introContainerView: UIView!
    
    var images = [UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house"),UIImage(named: "house")]
    var viewModel: HomeViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupKoladaView()
        self.viewModel?.getProperties()
        self.addObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.getPendingInvites()
    }
}

//MARK:- Functions
extension HomeViewController {
    func addObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(filterDataUpdated), name: Constants.NotificationCenterKey.homePageDataUpdateNotificationObserver, object: nil)
    }
    @objc func filterDataUpdated() {
        self.viewModel?.currentPage = 1
        Session.sharedInstance.properties = [Property]()
        self.viewModel?.getProperties()
    }
    func setupUI() {
        self.navigationItem.title = "Sould"
        self.setupNavBarUI(count: 0)
        let shouldShowIntro = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.introView)
        if shouldShowIntro {
            
        } else {
//            self.setupOnBoardView()
        }
//        self.introContainerView.isHidden = shouldShowIntro
    }
    func setupOnBoardView() {
        let firstPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let secondPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let thirdPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        if let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "Homepage"), contents: [firstPage, secondPage, thirdPage]) {
            self.present(onboardingVC, animated: true)
        }
    }
    func setupNavBarUI(count: Int) {
//        let button1 = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(didTapProfile))
//        self.navigationItem.leftBarButtonItem  = button1
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        filterBtn.setImage(UIImage(named: "user"), for: .normal)
        filterBtn.tintColor = .white
        filterBtn.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)

        let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 20, height: 20))
        lblBadge.backgroundColor = .red
        lblBadge.clipsToBounds = true
        lblBadge.layer.cornerRadius = 10
        lblBadge.textColor = UIColor.white
        lblBadge.font = .systemFont(ofSize: 10)
        lblBadge.textAlignment = .center

        if count > 0 {
            lblBadge.text = "\(count)"
            filterBtn.addSubview(lblBadge)
        }

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: filterBtn)
        
        
        let share = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(didTapShare))
        self.navigationItem.rightBarButtonItem  = share
    }
    func setupKoladaView() {
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
    }
    func openShareFeature(model: Property) {
        if let url = URL.init(string: model.url) {
            do {
                let data = try Data.init(contentsOf: url)
                let activityViewController = UIActivityViewController(activityItems: [model.listingId,model.images,url,data], applicationActivities: nil)   // and present it
                //            let textToShare = [ text ]
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            } catch {
                print("no data")
            }
        } else {
            let activityViewController = UIActivityViewController.init(activityItems: [model.listingId,model.images], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

//MARK: - IBActions
extension HomeViewController{
    @objc func didTapProfile() {
        self.viewModel?.didTapProfile()
    }
    @objc func didTapShare() {
        if self.viewModel?.currentProperty.listingId != "" {
            if let property = self.viewModel?.currentProperty {
                self.openShareFeature(model: property)
            }
        }
    }
    @IBAction func didTapIntro() {
        self.introContainerView.isHidden = true
        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaultsKey.introView)
        UserDefaults.standard.synchronize()
    }
}

//MARK: - Delegates

extension HomeViewController: HomeViewModelDelegate {
    func updateNavBar(count: Int) {
        self.setupNavBarUI(count: count)
    }
    
    func alert(with title: String, message: String) {
    }
    func validationError(error: String) {
    }
    func hideInfoLabel() {
    }
    func updatePropertyUI() {
        self.kolodaView.reloadData()
    }
}

//MARK: - Kolada View Delegates And Datasource
extension HomeViewController: KolodaViewDelegate,KolodaViewDataSource,KoladaOverlayDelegate {
    // Datasource
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return self.viewModel?.dataSource.count ?? 0
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as! KoladaOverlayView
        view.clipsToBounds = true
        view.currentIndex = index
        view.koladaDelegate = self
        if (self.viewModel?.dataSource[index].images.count ?? 0) > (self.viewModel?.currentPropertyImageIndex ?? 0) {
            if let imageUrl = self.viewModel?.dataSource[index].images[self.viewModel?.currentPropertyImageIndex ?? 0] {
                if let url = URL(string: imageUrl) {
                    view.overlayImageView.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }
        } else {
            self.viewModel?.currentPropertyImageIndex = 0
            if let imageUrl = self.viewModel?.dataSource[index].images.first {
                if let url = URL(string: imageUrl) {
                    view.overlayImageView.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }
        }
        
        if let data = self.viewModel?.dataSource[index] {
            view.bathroomStackView.isHidden = false
            view.bedroomStackView.isHidden = false
//            view.priceLabel.text = "$ \(data.price)"
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let minNumber = numberFormatter.string(from: NSNumber(value:data.price))
            view.priceLabel.text = "$ \(minNumber ?? "")"
            view.bathroomCountLabel.text = data.buildingData.bathroomTotal
            if data.buildingData.bathroomTotal == "0" {
                view.bathroomStackView.isHidden = true
            }
            if data.buildingData.bedroomsTotal == "0" {
                view.bedroomStackView.isHidden = true
            }
            view.bedroomCountLabel.text = data.buildingData.bedroomsTotal
            view.streetLabel.text = data.listingId
            view.nameLabel.text = data.addressData.city
            view.subNameLabel.text = data.addressData.communityName
        }
        
        return view
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("ActionImageOverlayView", owner: self, options: nil)?[0] as? ActionImageOverlayView
    }
    
    // Delegates
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("selected \(index)")
        self.viewModel?.didSelectProperyCard(index: index)
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(direction)
        if let model = self.viewModel {
            self.viewModel?.currentPropertyImageIndex = 0
            if index == model.dataSource.count - 2 {
                self.viewModel!.currentPage = self.viewModel!.currentPage + 1
                self.viewModel!.getProperties()
            }
            switch direction {
            case .left:
                model.markLikeOrDislike(property: model.dataSource[index], status: false)
            case .right:
                model.markLikeOrDislike(property: model.dataSource[index], status: true)
            default:
                print("")
            }
        }
    }
    func didSelectBottom(index: Int) {
        self.viewModel?.didSelectProperyCard(index: index)
    }
    func didSelectImage(index: Int) {
        self.viewModel?.didSelectProperyImage(index: index)
        self.kolodaView.reconfigureCards()
    }
}
