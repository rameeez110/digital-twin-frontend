//
//  LookingForViewController.swift
//  Sould
//
//  Created by Rameez Hasan on 14/08/2022.
//

import UIKit

class LookingForViewController: UIViewController {
    
    @IBOutlet weak var iamLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var luckyButton: UIButton!
    
    var viewModel: LookingForViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setuoUI()
    }
}

//MARK:- Functions
extension LookingForViewController {
    func setuoUI() {
        if self.viewModel?.screenType == .Looking  {
            self.iamLabel.text = "I am"
            self.profileButton.setTitle("Just Looking", for: .normal)
            self.luckyButton.setTitle("Ready to Commit", for: .normal)
        } else {
            self.iamLabel.text = ""
            self.profileButton.setTitle("Complete my Profile", for: .normal)
            self.luckyButton.setTitle("I'm Feeling Lucky", for: .normal)
        }
    }
}

//MARK: - IBActions
extension LookingForViewController{
    @IBAction func didTapCompleteProfile(){
        self.viewModel?.didTapProfile()
    }
    
    @IBAction func didTapLucky(){
        self.viewModel?.didTapLucky()
    }
}

//MARK: - Delegates

extension LookingForViewController: LookingForViewModelDelegate {
    func alert(with title: String, message: String) {
//        self.showAlert(title: title, msg: message)
    }
    func validationError(error: String) {
//        self.setupInfo(status: false)
//        self.infoLabel.text = error
    }
    func hideInfoLabel() {
//        self.setupInfo(status: true)
    }
    
}
