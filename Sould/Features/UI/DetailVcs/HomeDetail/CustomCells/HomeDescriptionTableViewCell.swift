//
//  HomeDescriptionTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 12/10/2022.
//

import UIKit

class HomeDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descStackView: UIStackView!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var landStackView: UIStackView!
    
    @IBOutlet weak var landLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var propertyDesc: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = Property()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "AgentsTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "agentTableCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HomeDescriptionTableViewCell {
    func bindData(data: Property) {
        if self.data.propertyDescription.isEmpty {
            self.descStackView.isHidden = true
        } else {
            self.descStackView.isHidden = false
            self.propertyDesc.text = data.propertyDescription
        }
        if self.data.landData.totalSize.isEmpty {
            self.landStackView.isHidden = true
        } else {
            self.landStackView.isHidden = false
            self.landLabel.text = "\(data.landData.totalSize) \(data.landData.acreage) \(data.landData.amenities) \(data.landData.sizeIrregular)"
        }
        if self.data.addressData.city.isEmpty {
            self.addressStackView.isHidden = true
        } else {
            self.addressStackView.isHidden = false
            self.addressLabel.text = "\(data.addressData.streetAddress) ,\(data.addressData.city) ,\(data.addressData.province) ,\(data.addressData.postalCode)"
        }
        self.tableView.reloadData()
    }
}

extension HomeDescriptionTableViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agentTableCell", for: indexPath) as! AgentsTableViewCell
        
        let model = self.data.agents[indexPath.row]
        cell.bindData(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.agents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
