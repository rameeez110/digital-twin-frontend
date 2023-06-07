//
//  Session.swift
//  Sould
//
//  Created by Rameez Hasan on 20/09/2022.
//

import UIKit

class Session {
    static let sharedInstance = Session()
    
    var token: String?
    var user: User?
    var properties: [Property]?
}
