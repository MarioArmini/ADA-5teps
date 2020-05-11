//
//  Extension.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import Foundation
import UIKit

let date = Date()
let formate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss") // Set output formate

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    func toString() -> String {
        return getFormattedDate(format: "dd/MM/yyyy")
    }
}
