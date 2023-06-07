//
//  PropertyLikeTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 28/09/2022.
//

import UIKit
import SwipeCellKit

class PropertyLikeTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var bedStackView: UIStackView!
    @IBOutlet weak var bathStackView: UIStackView!
    
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subnameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var streelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var houseImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PropertyLikeTableViewCell {
    func bindData(data: Property) {
        if data.isDeleted {
            self.houseImageView.image = UIImage(named: "deleted")
        } else {
            if let imageUrl = data.images.first {
                if let url = URL(string: imageUrl) {
                    self.houseImageView.sd_setImage(with: url, placeholderImage: UIImage())
                }
            } else {
                self.houseImageView.image = nil
            }
        }
        self.bedStackView.isHidden = true
        self.bathStackView.isHidden = true
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let minNumber = numberFormatter.string(from: NSNumber(value:data.price))
        self.priceLabel.text = "$ \(minNumber ?? "")"
//        self.priceLabel.text = "$ \(data.price)"
        self.bathroomLabel.text = data.buildingData.bathroomTotal
        self.bedroomLabel.text = data.buildingData.bedroomsTotal
        self.streelLabel.text = data.addressData.streetName
        self.nameLabel.text = data.features
        self.subnameLabel.text = data.nearBy
        self.descLabel.text = data.propertyDescription
        
        if data.buildingData.bathroomTotal != "0" {
            self.bathStackView.isHidden = false
        }
        if data.buildingData.bedroomsTotal != "0" {
            self.bedStackView.isHidden = false
        }
    }
}
