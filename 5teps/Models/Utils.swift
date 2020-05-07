//
//  Utils.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Utils {
    
    static func showMessage(vc: UIViewController, title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true)
    }
}
