//
//  CustomError.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import Foundation

struct CustomError {
    var errorCode : Int!
    var errorString : String!
    
    init(errorCode:Int? = nil,errorString: String) {
        self.errorCode = errorCode
        self.errorString = errorString
    }
    
    init()
    {
    
    }
}
