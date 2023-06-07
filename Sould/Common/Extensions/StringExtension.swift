//
//  StringExtension.swift
//  Sould
//
//  Created by Rameez Hasan on 29/09/2022.
//

import UIKit

extension String {
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self) ?? Date()
        return date
    }
}
