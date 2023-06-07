//
//  CollectionViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 02/10/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var tagButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
