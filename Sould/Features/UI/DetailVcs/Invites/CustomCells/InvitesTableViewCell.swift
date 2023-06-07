//
//  InvitesTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 26/01/2023.
//

import UIKit
import SwipeCellKit

class InvitesTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var makeAdminButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension InvitesTableViewCell {
    func bindData(data: Invite) {
        if let url = URL(string: data.fromUser.image) {
            self.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_new"))
        } else {
            self.userImageView.image = UIImage(named: "user_new")
        }

        self.pendingLabel.isHidden = data.status
        
        self.nameLabel.text = "\(data.fromUser.firstName) \(data.fromUser.lastName)"
    }
    
    func bindData(data: User) {
        if let url = URL(string: data.image) {
            self.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_new"))
        } else {
            self.userImageView.image = UIImage(named: "user_new")
        }

        self.nameLabel.text = "\(data.firstName) \(data.lastName)"
    }
}

