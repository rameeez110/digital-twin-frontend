//
//  HomeDetailTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

class HomeDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bathroomCountLabel: UILabel!
    @IBOutlet weak var bedroomCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var bathroomStackView: UIStackView!
    @IBOutlet weak var bedroomStackView: UIStackView!
    
    var data = Property()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.mapView.delegate = self
        
        //Collection view FLow layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize.width = UIScreen.main.bounds.width
        layout.itemSize.height = 250
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView!.collectionViewLayout = layout
        let nibName = UINib(nibName: "HomeImagesCollectionViewCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "homeImagesCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Collection View Delegates
extension HomeDetailTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeImagesCell", for: indexPath) as! HomeImagesCollectionViewCell
        
        let imageUrl = self.data.images[indexPath.row]
        if let url = URL(string: imageUrl) {
            cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: self.data.images.first ?? ""))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.data.images.count > indexPath.row + 1 {
            collectionView.scrollToItem(at: IndexPath.init(row: indexPath.row + 1, section: 0), at: .right, animated: true)
        }
    }
}
