//
//  AgentsTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 12/10/2022.
//

import UIKit

class AgentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension AgentsTableViewCell {
    func bindData(model: Agent) {
        self.nameLabel.text = model.name
        self.phoneLabel.text = model.phone
        self.webLabel.text = model.website
        self.officeLabel.text = model.office
        self.positionLabel.text = model.position
    }
}
