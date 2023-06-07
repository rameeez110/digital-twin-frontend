//
//  ProfileTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 28/09/2022.
//

import UIKit

protocol EditProfileCellDelegate: NSObjectProtocol {
    func didEndEditing(indexPath: IndexPath,textField: UITextField)
}

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!

    weak var delegate: EditProfileCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ProfileTableViewCell {
    func bindData(model: ProfileViewModelDataSource) {
        self.titleLabel.text = model.title
        self.titleTextField.text = model.text
    }
    func setIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}

// MARK:- Delegates
extension ProfileTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let index = self.indexPath {
            self.delegate?.didEndEditing(indexPath: index,textField: self.titleTextField)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
