//
//  FilterViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import SVProgressHUD
import CoreLocation
import GoogleMaps
import MapKit
import GooglePlaces

class FilterViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placesTableView: UITableView!
    
    var viewModel: FilterViewModelProtocol?
    var isComingFromRegistration = false
    private var tableDataSource: GMSAutocompleteTableDataSource!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var isSelectedGoogleAddress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupLocation()
        self.setupNavBarUI(count: 0)
        self.viewModel?.mapDataSource()
        self.viewModel?.populateData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.getPendingInvites()
    }
}

//MARK:- Functions
extension FilterViewController {
    func setupUI() {
        self.registerNibsAndSetupTableView()
    }
    func setupLocation() {
//        // For use in foreground
        self.isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    func isAuthorizedtoGetUserLocation() {
        self.locationManager.requestWhenInUseAuthorization()
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
        
        let button2 = UIBarButtonItem(image: UIImage(named: "tick"), style: .plain, target: self, action: #selector(didTapDone))
        self.navigationItem.rightBarButtonItem  = button2
    }
    func registerNibsAndSetupTableView(){
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "FilterTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "filterTableCell")
        let bedroomCell = UINib(nibName: "FilterBedroomTableViewCell", bundle:nil)
        self.tableView.register(bedroomCell, forCellReuseIdentifier: "bedroomFilterTableCell")
        
        self.tableView.estimatedRowHeight = 58
        
        let dummyViewHeight = CGFloat(0)
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        // Add Refresh Control to Table View
//        if #available(iOS 10.0, *) {
//            tableView.refreshControl = refreshControl
//        } else {
//            tableView.addSubview(refreshControl)
//        }
        self.tableDataSource = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.country = "CAN"
        self.tableDataSource.autocompleteFilter = filter
        self.tableDataSource.delegate = self
        
        self.placesTableView.delegate = self.tableDataSource
        self.placesTableView.dataSource = self.tableDataSource
    }
}

//MARK: - IBActions
extension FilterViewController{
    @objc func didTapProfile() {
        self.viewModel?.didTapProfile()
    }
    @objc func didTapDone() {
        SVProgressHUD.show()
        self.viewModel?.updateFilters()
    }
}

//MARK: - Delegates

extension FilterViewController: FilterViewModelDelegate {
    func fetchedCoordinates(cord: CLLocationCoordinate2D) {
        // nothing to do here anything yet
    }
    
    func alert(with title: String, message: String) {
//        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
//        self.setupInfo(status: false)
//        self.infoLabel.text = error
    }
    func hideInfoLabel() {
        SVProgressHUD.dismiss()
        if self.isComingFromRegistration {
            self.viewModel?.goToHome()
        }
    }
    func reloadUI() {
        self.tableView.reloadData()
    }
    func updateNavbarUI(count: Int) {
        self.setupNavBarUI(count: count)
    }
}

extension FilterViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bedroomFilterTableCell", for: indexPath) as! FilterBedroomTableViewCell
            cell.delegate = self
            cell.index = indexPath.row
            if indexPath.row == 1 {
                cell.titleLabel.text = "Bedrooms"
                cell.bindData(ranges: self.viewModel?.filter.bedRoom ?? Ranges())
            } else if indexPath.row == 2 {
                cell.titleLabel.text = "Bathrooms"
                cell.bindData(ranges: self.viewModel?.filter.bathRoom ?? Ranges())
            } else if indexPath.row == 3 {
                cell.titleLabel.text = "Parking"
                cell.bindData(ranges: self.viewModel?.filter.parking ?? Ranges())
            } else {
                cell.titleLabel.text = "Distance"
                cell.bindData(radius: self.viewModel?.filter.location.radius ?? 0)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableCell", for: indexPath) as! FilterTableViewCell
            cell.delegate = self
            if let model = self.viewModel?.dataSource[indexPath.row] {
                cell.bindData(model: model,filter: self.viewModel?.filter)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 {
            return 55
        } else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FilterViewController: FilterTableCellDelegate {
    func didUpdateTags(type: FilterType, keywords: [KeyWord]) {
        if type == .Keywords {
            self.viewModel?.filter.keywords = [String]()
            for each in keywords {
                self.viewModel?.filter.keywords.append(each.text)
            }
        } else {
            self.viewModel?.filter.houseTypes = [HouseType]()
            for i in 0..<keywords.count {
                if keywords[i].isSelected {
                    self.viewModel?.filter.houseTypes.append(HouseType(rawValue: i) ?? .Detached)
                }
            }
        }
    }
    
    func didUpdateCityTF(model: FilterViewModelDataSource, textField: UITextField) {
        switch model.type {
        case .City:
            self.isSelectedGoogleAddress = false
//            self.viewModel?.filter.address = textField.text!
            self.tableDataSource.sourceTextHasChanged(textField.text!)
            if textField.text! == "" {
                self.placesTableView.isHidden = true
            } else {
                self.placesTableView.isHidden = false
            }
//            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        default:
            print("")
        }
    }
    
    func didUpdateFilters(model: FilterViewModelDataSource) {
        switch model.type {
        case .City:
            self.viewModel?.filter.city = model.text
            if self.isSelectedGoogleAddress {
                
            } else {
                self.viewModel?.filter.address = model.text
            }
//            self.viewModel?.getGeocodedCoordinates(address: model.text)
        case .Bedroom:
            self.viewModel?.filter.bedRoom.min = model.min
            self.viewModel?.filter.bedRoom.max = model.max
        case .Bathroom:
            self.viewModel?.filter.bathRoom.min = model.min
            self.viewModel?.filter.bathRoom.max = model.max
        case .Parking:
            self.viewModel?.filter.parking.min = model.min
            self.viewModel?.filter.parking.max = model.max
        case .Price:
            self.viewModel?.filter.price.min = model.min
            self.viewModel?.filter.price.max = model.max
        case .Keywords:
            if model.text != "" {
                self.viewModel?.filter.keywords.append(model.text)
            }
        case .Distance:
            self.viewModel?.filter.location.radius = model.max
        case .DefaultKeywords:
            print("")
        }
    }
}

extension FilterViewController: FilterBedroomTableCellDelegate {
    func didUpdateFilters(index: Int, dataSource: [BedroomFilterData]) {
        let type = FilterType(rawValue: index) ?? .Bedroom
        let min = dataSource.filter({$0.isSelected == true}).first
        let last = dataSource.filter({$0.isSelected == true}).last
        switch type {
        case .Bedroom:
            self.viewModel?.filter.bedRoom.min = min?.intVal ?? 0
            self.viewModel?.filter.bedRoom.max = last?.intVal ?? 0
        case .Bathroom:
            self.viewModel?.filter.bathRoom.min = min?.intVal ?? 0
            self.viewModel?.filter.bathRoom.max = last?.intVal ?? 0
        case .Parking:
            self.viewModel?.filter.parking.min = min?.intVal ?? 0
            self.viewModel?.filter.parking.max = last?.intVal ?? 0
        case .Distance:
            self.viewModel?.filter.location.radius = Int(min?.title ?? "0") ?? 50
        default:
            print("")
        }
    }
}

extension FilterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.viewModel?.filter.location.lat = "\(location.coordinate.latitude)"
            self.viewModel?.filter.location.long = "\(location.coordinate.longitude)"
            self.reverseGeocodeCoordinate(location.coordinate)
            
            self.locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        } else if status == .authorizedWhenInUse {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                _ = address.lines as [String]?
                _ = address.administrativeArea
                if let province = address.administrativeArea {
                    self.viewModel?.filter.province = province
                }
                if let city = address.locality {
                    self.viewModel?.filter.city = city
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                }
            }
        }
    }
}

extension FilterViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        self.placesTableView.reloadData()
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        self.placesTableView.reloadData()
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        // Do something with the selected place.
        self.placesTableView.isHidden = true
        var loc = Location()
        loc.lat = String(place.coordinate.latitude)
        loc.long = String(place.coordinate.longitude)
        self.isSelectedGoogleAddress = true
        self.viewModel?.filter.address = place.formattedAddress ?? ""
        self.viewModel?.filter.location.lat = String(place.coordinate.latitude)
        self.viewModel?.filter.location.long = String(place.coordinate.longitude)
        if let comp = place.addressComponents {
            for each in comp {
                if let province = each.types.first, province == "administrative_area_level_1" {
                    self.viewModel?.filter.province = each.name
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}
