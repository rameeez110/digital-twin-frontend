//
//  FilterBedroomTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 29/10/2022.
//

import UIKit

struct BedroomFilterData {
    var title = String()
    var intVal = Int()
    var isSelected = false
}

protocol FilterBedroomTableCellDelegate: NSObjectProtocol {
    func didUpdateFilters(index: Int,dataSource: [BedroomFilterData])
}

class FilterBedroomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = ["0","1","2","3","4","5+"]
    var distances = ["1","3","5","10","20","50+"]
    var dataSource = [BedroomFilterData]()
    weak var delegate: FilterBedroomTableCellDelegate?
    var index = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dataSource = [BedroomFilterData]()
        for i in 0..<self.data.count {
            var model = BedroomFilterData()
            model.title = self.data[i]
            model.intVal = i
            self.dataSource.append(model)
        }
        
        //Collection view FLow layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize.width = 40
        layout.itemSize.height = 40
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView!.collectionViewLayout = layout
        let nibName = UINib(nibName: "BedroomFilterCollectionViewCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "bedroomFilterCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FilterBedroomTableViewCell {
    func bindData(ranges: Ranges,_ index: Int = Int()) {
        self.dataSource = [BedroomFilterData]()
        for i in 0..<self.data.count {
            var model = BedroomFilterData()
            model.title = self.data[i]
            model.intVal = i
            self.dataSource.append(model)
        }
        for i in 0..<self.dataSource.count {
            if i == ranges.min || ( i > ranges.min && i < ranges.max) || i == ranges.max {
                self.dataSource[i].isSelected = true
            } else {
                self.dataSource[i].isSelected = false
            }
        }
        self.collectionView.reloadData()
    }
    func bindData(radius: Int) {
        self.dataSource = [BedroomFilterData]()
        for i in 0..<self.distances.count {
            var model = BedroomFilterData()
            model.title = self.distances[i]
            model.intVal = i
            if let rad = Int(model.title) {
                if radius == rad {
                    model.isSelected = true
                }
            } else {
                if model.title == "50+" {
                    if radius == 50 {
                        model.isSelected = true
                    }
                }
            }
            self.dataSource.append(model)
        }
        self.collectionView.reloadData()
    }
}

extension FilterBedroomTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bedroomFilterCollectionCell", for: indexPath) as! BedroomFilterCollectionViewCell
        let model = self.dataSource[indexPath.row]
        cell.titleLabel.text = model.title
        if model.isSelected {
            cell.backgroundColor = CommonClass.sharedInstance.appThemeColor()
        } else {
            cell.backgroundColor = .white
        }
            
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataSource[indexPath.row].isSelected = !self.dataSource[indexPath.row].isSelected
        if self.index == 5 {
            if self.dataSource[indexPath.row].isSelected {
                for i in 0..<self.dataSource.count {
                    if i != indexPath.row {
                        self.dataSource[i].isSelected = false
                    }
                }
            }
            collectionView.reloadData()
        } else {
            collectionView.reloadItems(at: [indexPath])
        }
        
        self.delegate?.didUpdateFilters(index: self.index, dataSource: self.dataSource)
    }
}
