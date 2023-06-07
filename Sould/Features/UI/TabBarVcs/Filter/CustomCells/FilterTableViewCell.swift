//
//  FilterTableViewCell.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import SwiftRangeSlider

protocol FilterTableCellDelegate: NSObjectProtocol {
    func didUpdateFilters(model: FilterViewModelDataSource)
    func didUpdateTags(type: FilterType, keywords: [KeyWord])
    func didUpdateCityTF(model: FilterViewModelDataSource, textField: UITextField)
}

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: FilterTableCellDelegate?
    var model: FilterViewModelDataSource?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.regesterCollectionViewCells()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func regesterCollectionViewCells() {
        //Collection view FLow layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize.width = UIScreen.main.bounds.width / 2 - 30
        layout.itemSize.height = 45
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        self.tagsCollectionView!.collectionViewLayout = layout
        let photosNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.tagsCollectionView.register(photosNib, forCellWithReuseIdentifier: "filterTagsCollectionCell")
    }
}

extension FilterTableViewCell {
    func bindData(model: FilterViewModelDataSource,filter: Filter?) {
        self.model = model
        self.titleLabel.text = model.title
        self.titleTextField.text = model.text
        self.titleLabel.isHidden = false
        
        if model.filterDataType == .RangeSlider {
            self.titleTextField.isUserInteractionEnabled = false
            self.rangeSlider.isHidden = false
        } else {
            self.titleTextField.isUserInteractionEnabled = true
            self.rangeSlider.isHidden = true
            if model.type == .DefaultKeywords {
                self.titleLabel.isHidden = true
                self.titleTextField.isUserInteractionEnabled = false
            }
        }
        
        if model.filterDataType == .Tags {
            self.tagsCollectionView.isHidden = false
            if model.type == .DefaultKeywords {
                self.collectionViewHeightConstraint.constant = 150
            } else {
                self.collectionViewHeightConstraint.constant = 45
            }
            self.tagsCollectionView.reloadData()
        } else {
            self.tagsCollectionView.isHidden = true
        }
        
        switch model.type {
        case .City:
            self.titleTextField.text = filter?.address ?? ""
        case .Price:
            let min = Int(filter?.price.min ?? 0)
            let max = Int(filter?.price.max ?? 0)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let minNumber = numberFormatter.string(from: NSNumber(value:min))
            let maxNumber = numberFormatter.string(from: NSNumber(value:max))
            self.titleTextField.text = "$\(minNumber ?? "") - $\(maxNumber ?? "")"
            if filter?.price.max == 5000000 {
                self.titleTextField.text = "$\(minNumber ?? "") - $\(maxNumber ?? "")+"
            }
            self.rangeSlider.maximumValue = 5000000
            self.rangeSlider.minimumValue = 0
            self.rangeSlider.stepValue = 50000
            self.rangeSlider.lowerValue = Double(filter?.price.min ?? 0)
            self.rangeSlider.upperValue = Double(filter?.price.max ?? 0)
        case .Keywords:
            self.titleTextField.text = ""
        case .DefaultKeywords:
            self.titleTextField.text = ""
        case .Bedroom:
            self.titleTextField.text = "\(filter?.bedRoom.min ?? 0) - \(filter?.bedRoom.max ?? 0)"
            if filter?.bedRoom.max == 6 {
                self.titleTextField.text = "\(filter?.bedRoom.min ?? 0) - 5+"
            }
            self.rangeSlider.stepValue = 1
            self.rangeSlider.maximumValue = 6
            self.rangeSlider.minimumValue = 0
            self.rangeSlider.lowerValue = Double(filter?.bedRoom.min ?? 0)
            self.rangeSlider.upperValue = Double(filter?.bedRoom.max ?? 0)
        case .Bathroom:
            self.titleTextField.text = "\(filter?.bathRoom.min ?? 0) - \(filter?.bathRoom.max ?? 0)"
            if filter?.bathRoom.max == 6 {
                self.titleTextField.text = "\(filter?.bathRoom.min ?? 0) - 5+"
            }
            self.rangeSlider.stepValue = 1
            self.rangeSlider.maximumValue = 6
            self.rangeSlider.minimumValue = 0
            self.rangeSlider.lowerValue = Double(filter?.bathRoom.min ?? 0)
            self.rangeSlider.upperValue = Double(filter?.bathRoom.max ?? 0)
        case .Parking:
            self.titleTextField.text = "\(filter?.parking.min ?? 0) - \(filter?.parking.max ?? 0)"
            if filter?.parking.max == 6 {
                self.titleTextField.text = "\(filter?.parking.min ?? 0) - 5+"
            }
            self.rangeSlider.stepValue = 1
            self.rangeSlider.maximumValue = 6
            self.rangeSlider.minimumValue = 0
            self.rangeSlider.lowerValue = Double(filter?.parking.min ?? 0)
            self.rangeSlider.upperValue = Double(filter?.parking.max ?? 0)
        case .Distance:
            self.titleTextField.text = "\(filter?.location.radius ?? 0) km"
            self.rangeSlider.stepValue = 1
            self.rangeSlider.maximumValue = 300
            self.rangeSlider.minimumValue = 0
            self.rangeSlider.lowerValue = 0
            self.rangeSlider.upperValue = Double(filter?.location.radius ?? 0)
        }
    }
}

// MARK:- Action

extension FilterTableViewCell {
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider) {
//        print("\(rangeSlider.lowerValue), \(rangeSlider.upperValue)")
        if var model = self.model {
            model.min = Int(rangeSlider.lowerValue)
            model.max = Int(rangeSlider.upperValue)

            self.titleTextField.text = "\(model.min) - \(model.max)"
            self.delegate?.didUpdateFilters(model: model)
    
            if model.type == .Price {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let minNumber = numberFormatter.string(from: NSNumber(value:model.min))
                let maxNumber = numberFormatter.string(from: NSNumber(value:model.max))
                self.titleTextField.text = "$\(minNumber ?? "") - $\(maxNumber ?? "")"
                if model.max == 5000000 {
//                    self.titleTextField.text = "$\(model.min) - $\(model.max)+"
                    self.titleTextField.text = "$\(minNumber ?? "") - $\(maxNumber ?? "")+"
                }
            } else if model.max == 6 {
                self.titleTextField.text = "\(model.min) - 5+"
            }
            
            if model.type == .Distance {
                self.titleTextField.text = "\(model.max) km"
            }
        }
    }
}

// MARK:- Delegates
extension FilterTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var model = self.model {
            switch model.type {
            case .City:
                model.text = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                self.delegate?.didUpdateFilters(model: model)
            case .Keywords:
                model.text = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                self.delegate?.didUpdateFilters(model: model)
                if model.text != "" {
                    self.model?.keywords.append(KeyWord(text: model.text))
                    self.tagsCollectionView.reloadData()
                }
                textField.text = ""
            default:
                print()
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if var model = self.model {
            switch model.type {
            case .City:
                self.delegate?.didUpdateCityTF(model: model, textField: textField)
            default:
                print()
            }
        }
        return true
    }
}

// MARK: - Delegates and Datasource
extension FilterTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.keywords.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterTagsCollectionCell", for: indexPath) as! CollectionViewCell
        
        if var mdl = self.model {
            cell.tagLabel.text = mdl.keywords[indexPath.row].text
            if mdl.type == .Keywords {
                cell.tagButton.isHidden = false
                cell.tagButton.tag = indexPath.row
                cell.tagButton.addTarget(self, action: #selector(crossTapped(sender:)), for: .touchUpInside)
            } else {
                cell.tagButton.isHidden = true
                if mdl.keywords[indexPath.row].isSelected {
                    cell.containerView.backgroundColor = CommonClass.sharedInstance.appThemeColor()
                } else {
                    cell.containerView.backgroundColor = .white
                    cell.containerView.borderColor = CommonClass.sharedInstance.appThemeColor()
                    cell.containerView.borderWidth = 0.5
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.model?.keywords[indexPath.row].isSelected ?? false {
            self.model?.keywords[indexPath.row].isSelected = false
        } else {
            self.model?.keywords[indexPath.row].isSelected = true
        }
        self.tagsCollectionView.reloadData()
        if let keywords = self.model?.keywords {
            self.delegate?.didUpdateTags(type: .DefaultKeywords, keywords: keywords)
        }
    }
    @objc func crossTapped(sender:UIButton){
        self.model?.keywords.remove(at: sender.tag)
        self.tagsCollectionView.reloadData()
        if let keywords = self.model?.keywords {
            self.delegate?.didUpdateTags(type: .Keywords, keywords: keywords)
        }
    }
}
