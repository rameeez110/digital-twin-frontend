//
//  Attachment.swift
//  Sould
//
//  Created by Rameez Hasan on 28/09/2022.
//

import UIKit

struct Attachment {
    var type = AttachmentTypes.Image
    var name = String()
    var id = String()
    var link = String()
    var userId = Int()
    var fileType = String()
    var data: Data?
    var isUpdated = false
    init() {
        
    }
    init(type: AttachmentTypes,name: String) {
        self.type = type
        self.name = name
    }
    
    var dictionary: [String: Any] {
      return [
        "type": self.type.rawValue,
        "attachmentLink": self.link,
        "name": self.name,
      ]
    }
    
    var typeString: String {
        switch type {
        case .Pdf:
            return "Pdf"
        case .Image:
            return "Image"
        }
    }
}

enum AttachmentTypes: Int {
    case Image = 0,Pdf
}
