//
//  HomeMapTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 12/10/2022.
//

import UIKit
import GoogleMaps

class HomeMapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var data = Property()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HomeMapTableViewCell {
    func bindData(data: Property) {
        self.data = data
        let lat = Double(self.data.addressData.latitude) ?? Double()
        let long = Double(self.data.addressData.longitude) ?? Double()
        print("lat: \(lat) long: \(long)")
        let loc = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        let camera = GMSCameraPosition(target:loc, zoom: Float(12))
        self.mapView.camera = camera
        DispatchQueue.main.async {
            self.mapView.animate(to: camera)
        }
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = data.addressData.communityName
        marker.snippet = data.addressData.streetName
        DispatchQueue.main.async {
            marker.map = self.mapView
        }
    }
}
