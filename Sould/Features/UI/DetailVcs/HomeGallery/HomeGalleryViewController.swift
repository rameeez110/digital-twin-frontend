//
//  HomeGalleryViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 17/10/2022.
//

import UIKit

class HomeGalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = Property()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
}

extension HomeGalleryViewController {
    func setupUI() {
        //Collection view FLow layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize.width = UIScreen.main.bounds.width
        layout.itemSize.height = UIScreen.main.bounds.height
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView!.collectionViewLayout = layout
        let nibName = UINib(nibName: "HomeImagesCollectionViewCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "homeImagesCell")
    }
}

//MARK: - Collection View Delegates
extension HomeGalleryViewController: UICollectionViewDelegate,UICollectionViewDataSource {
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
}
