//
//  MapViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var iamLabel: UILabel!
    @IBOutlet weak var propertyAddressLabel: UILabel!
    @IBOutlet weak var propertyCityLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var luckyButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var propertyAddressView: UIView!
    
    @IBOutlet weak var propertyAddressViewTopConstraint: NSLayoutConstraint!
    
    var viewModel: MapViewModelProtocol?
    private var tableDataSource: GMSAutocompleteTableDataSource!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var rect = GMSMutablePath()
    var paths = [CLLocationCoordinate2D]()
    var polygon: GMSPolygon?
    var circles = [GMSCircle]()
    var isDrawingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
}

//MARK:- Functions
extension MapViewController {
    func setupTableView() {
        self.tableDataSource = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.country = "CAN"
        self.tableDataSource.autocompleteFilter = filter
        self.tableDataSource.delegate = self
        
        self.tableView.delegate = self.tableDataSource
        self.tableView.dataSource = self.tableDataSource
    }
    func setupUI(_ haveDataSource: Bool = Bool()) {
        if !haveDataSource {
            self.viewModel?.getDataSource()
        }
        self.mapView.clear()
        let lat = Double(self.viewModel?.dataSource?.first?.addressData.latitude ?? "") ?? Double()
        let long = Double(self.viewModel?.dataSource?.first?.addressData.longitude ?? "") ?? Double()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        self.mapView.camera = camera
        self.mapView.animate(to: camera)
        self.mapView.delegate = self
        
        if let data = self.viewModel?.dataSource {
            DispatchQueue.main.async
            {
                for i in 0..<data.count {
                    let each  = data[i]
                    let lat = Double(each.addressData.latitude) ?? Double()
                    let long = Double(each.addressData.longitude) ?? Double()
                    print("lat: \(lat) long: \(long)")
                    let loc = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                    let marker = GMSMarker(position: loc)
                    marker.tracksInfoWindowChanges = true
                    marker.branch = i
                    marker.title = each.addressData.city
                    marker.map = self.mapView
                }
            }
        }
        self.setupNavBarUI()
    }
    
    func setupNavBarUI() {
        if self.isDrawingMode {
            let button1 = UIBarButtonItem(image: UIImage(named: "pentagon_red"), style: .plain, target: self, action: #selector(didTapPolygon))
            button1.tintColor = .red
            self.navigationItem.rightBarButtonItem  = button1
        } else {
            let button1 = UIBarButtonItem(image: UIImage(named: "pentagon"), style: .plain, target: self, action: #selector(didTapPolygon))
            button1.tintColor = .white
            self.navigationItem.rightBarButtonItem  = button1
        }
    }
    @objc func didTapPolygon() {
        self.isDrawingMode = !self.isDrawingMode
        
        self.setupNavBarUI()
        
        if self.isDrawingMode {
            self.polygon?.map = nil
            for each in self.circles {
                each.map = nil
            }
        } else {
            // Create a rectangular path
            self.rect.removeAllCoordinates()
            var maxLat = self.paths.last?.latitude ?? CLLocationDegrees()
            var maxLong = self.paths.last?.longitude ?? CLLocationDegrees()
            var minLat = self.paths.first?.latitude ?? CLLocationDegrees()
            var minLong = self.paths.first?.longitude ?? CLLocationDegrees()
            for each in self.paths {

                if each.latitude < minLat {
                    minLat = each.latitude
                }
                if each.longitude < minLong {
                    minLong = each.longitude
                }
                if each.latitude > maxLat {
                    maxLat = each.latitude
                }
                if each.longitude > maxLong {
                    maxLong = each.longitude
                }
            }
            
            self.polygon?.map = nil
            self.polygon?.layer.removeFromSuperlayer()
            
            if self.paths.count > 2 {
                for each in self.circles {
                    each.map = nil
                }
                let loc = CLLocationCoordinate2DMake((maxLat + minLat) * 0.5, (maxLong + minLong) * 0.5)
                var location = Location()
                location.lat = String(loc.latitude)
                location.long = String(loc.longitude)
                location.radius = 25
                self.viewModel?.getProperties(location: location)
                self.paths.removeAll()
                self.rect.removeAllCoordinates()
            }
        }
    }
}

//MARK: - IBActions
extension MapViewController{
//    @objc func markerPropertyPressed(sender: UIButton) {
//        if let property = self.viewModel?.dataSource?[sender.tag] {
//            self.viewModel?.navigateToHomeDetail(property: property)
//        }
//    }
}

//MARK: - Delegates

extension MapViewController: MapViewModelDelegate {
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
    func updatePropertyUI() {
        self.setupUI(true)
    }
}
extension MapViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        self.tableView.reloadData()
        print("self.tableView.contentSize")
        print(self.tableView.contentSize)
        self.propertyAddressViewTopConstraint.constant = self.tableView.contentSize.height
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        self.tableView.reloadData()
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        // Do something with the selected place.
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        self.tableView.isHidden = true
        var loc = Location()
        loc.lat = String(place.coordinate.latitude)
        loc.long = String(place.coordinate.longitude)
        loc.radius = 25
        self.viewModel?.getProperties(location: loc)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update the GMSAutocompleteTableDataSource with the search text.
        tableDataSource.sourceTextHasChanged(searchText)
        if searchText == "" {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
            if let properties = self.viewModel?.dataSource, properties.count > 0 {
                if let property = properties.filter({$0.addressData.streetAddress.lowercased().contains(searchText.lowercased())}).first {
                    self.propertyAddressView.isHidden = false
                    self.view.bringSubviewToFront(self.propertyAddressView)
                    self.propertyAddressLabel.text = property.addressData.streetAddress
                    self.propertyCityLabel.text = "\(property.addressData.streetName), \(property.addressData.city)"
                } else {
                    self.propertyAddressView.isHidden = true
                }
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}

extension MapViewController: GMSMapViewDelegate {
//    didChangeCameraPosition
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("han bhai")
        print(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")

        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6)
        
        if self.isDrawingMode {
            let circle = GMSCircle(position: camera.target, radius: 50)
            self.circles.append(circle)
            circle.strokeColor = UIColor.red.withAlphaComponent(0.5)
            circle.strokeWidth = 2.5
            circle.map = mapView
            
            self.paths.append(coordinate)
            
            self.rect.removeAllCoordinates()
            for each in self.paths {
                self.rect.add(each)
            }
            
            self.polygon?.map = nil
            self.polygon?.layer.removeFromSuperlayer()
            
            // Create the polygon, and assign it to the map.
            self.polygon = GMSPolygon(path: self.rect)
            self.polygon?.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
            self.polygon?.strokeColor = .black
            self.polygon?.strokeWidth = 2
            self.polygon?.map = mapView
        }
    }
    
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
        if self.viewModel?.dataSource?.count ?? 0 > marker.branch {
            if let property = self.viewModel?.dataSource?[marker.branch] {
                self.viewModel?.navigateToHomeDetail(property: property)
            }
        }
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        let index = marker.branch
        guard let model = self.viewModel?.dataSource?[index] else {
            return view
        }
        
        let bathImage = UIImageView(frame: CGRect.init(x: 5, y: 170, width: 15, height: 15))
        bathImage.image = UIImage(named: "rest_room_icon")
        view.addSubview(bathImage)
        
        let bedImage = UIImageView(frame: CGRect.init(x: 45, y: 170, width: 15, height: 15))
        bedImage.image = UIImage(named: "room_icon")
        view.addSubview(bedImage)
        
        let img = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 160))
        if let imageUrl = self.viewModel?.dataSource?[index].images.first {
            if let url = URL(string: imageUrl) {
                img.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }
        view.addSubview(img)
        
        if model.buildingData.bathroomTotal != "0" {
            let bathRoomLabel = UILabel(frame: CGRect.init(x: 25, y: 170, width: 30, height: 15))
            bathRoomLabel.text = "\(model.buildingData.bathroomTotal)"
            view.addSubview(bathRoomLabel)
        }
        if model.buildingData.bedroomsTotal != "0" {
            let bedRoomLabel = UILabel(frame: CGRect.init(x: 70, y: 170, width: 30, height: 15))
            bedRoomLabel.text = "\(model.buildingData.bedroomsTotal)"
            view.addSubview(bedRoomLabel)
        }
        
        let priceLabel = UILabel(frame: CGRect.init(x: 105, y: 170, width: 95, height: 15))
        priceLabel.text = "$ \(model.price)"
        view.addSubview(priceLabel)
        
//        let tapButton = UIButton()
//        tapButton.setTitle("", for: .normal)
//        tapButton.setTitleColor(.blue, for: .normal)
//        tapButton.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        tapButton.tag = index
//        tapButton.addTarget(self, action: #selector(markerPropertyPressed), for: .touchUpInside)
        
        return view
    }
}

extension GMSMarker {
    var branch: Int {
        set(indexPath) {
            self.userData = indexPath
        }

        get {
            return self.userData as? Int ?? 0
       }
   }
}
