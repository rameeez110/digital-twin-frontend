//
//  KoladaOverlayView.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit
import Koloda

private let overlayRightImageName = "Heart"
private let overlayLeftImageName = "thumbs_down"

protocol KoladaOverlayDelegate: NSObjectProtocol {
    func didSelectBottom(index: Int)
    func didSelectImage(index: Int)
}

class KoladaOverlayView: OverlayView {
    
    @IBOutlet weak var bathroomCountLabel: UILabel!
    @IBOutlet weak var bedroomCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var bathroomStackView: UIStackView!
    @IBOutlet weak var bedroomStackView: UIStackView!
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var currentIndex = Int()
    weak var koladaDelegate: KoladaOverlayDelegate?
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: CGRect.init(x: UIScreen.main.bounds.width / 2 - 80, y: UIScreen.main.bounds.height / 2 - 80, width: 80, height: 80))
        self.addSubview(imageView)
        
        return imageView
        }()

    override var overlayState: SwipeResultDirection? {
        didSet {
            overlayImageView.backgroundColor = .white
            overlayImageView.contentMode = .scaleAspectFit
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }

    @IBAction func didTapBottom() {
        self.koladaDelegate?.didSelectBottom(index: self.currentIndex)
    }
    @IBAction func didTapImage() {
        self.koladaDelegate?.didSelectImage(index: self.currentIndex)
    }
}
