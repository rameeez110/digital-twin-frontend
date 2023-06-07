//
//  ActionImageOverlayView.swift
//  Sould
//
//  Created by Rameez Hasan on 20/10/2022.
//

import UIKit
import Koloda

private let overlayRightImageName = "Heart"
private let overlayLeftImageName = "thumbs_down"

class ActionImageOverlayView: OverlayView {
    
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
}

