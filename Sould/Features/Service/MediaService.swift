//
//  MediaService.swift
//  Sould
//
//  Created by Rameez Hasan on 28/09/2022.
//

import UIKit
import SwiftyJSON

class MediaService {
    static let sharedInstance = MediaService()
    
    func uploadImage(image: UIImage,completionHandler:@escaping (AnyObject?,CustomError?) -> Void) {
        
        let parameters = [String : AnyObject]()
        
        NetworkManager.sharedInstance.uploadFile(request: image.jpegData(compressionQuality: 0.5)!, completionHandler: { (response) in
            
            switch(response){
            case .Success(let json):
                print("Success with JSON: \(String(describing: json))")
                let swiftyJson = JSON(json?.value as Any)
                if swiftyJson["failure"] != JSON.null {
                    var error = CustomError.init(errorCode: swiftyJson["code"].intValue, errorString: "Api Error")
                    error.errorString = swiftyJson["failure"].string ?? "Api Error"
                    completionHandler(nil,error)
                } else {
                    if let id = swiftyJson["success"].bool {
                        var attachment = Attachment()
                        if id {
                            if let value = swiftyJson["data"].string{
                                attachment.link = value
                            }
                        }
                        completionHandler(attachment as AnyObject,nil)
                    }
                }
                break
            case .FailureDueToService(let error):
                completionHandler(nil,error)
                break
            case .Failure(_):
                let error2 = CustomError.init(errorCode: 250, errorString: "Failure")
                completionHandler(nil,error2)
                break
            }
        })
    }
}
