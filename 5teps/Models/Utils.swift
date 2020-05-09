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
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    public static func getArrayIcon() -> [String] {
        var icons = [String]()
        
        for i in 0x1F601...0x1F64F {
            let c = String(UnicodeScalar(i)!)
            icons.append(c)
        }
        return icons
    }
    public static func getArrayColor() -> [String] {
        var colors = [String]()
        colors.append("ffffff")
        colors.append("ff0000")
        colors.append("ff4000")
        colors.append("ff8000")
        colors.append("ffbf00")
        colors.append("ffff00")
        colors.append("bfff00")
        colors.append("80ff00")
        colors.append("40ff00")
        colors.append("00ff00")
        colors.append("00ff40")
        colors.append("00ff80")
        colors.append("00ffbf")
        colors.append("00ffff")
        colors.append("00bfff")
        colors.append("0080ff")
        colors.append("0040ff")
        colors.append("0000ff")
        colors.append("4000ff")
        colors.append("8000ff")
        colors.append("bf00ff")
        colors.append("ff00ff")
        colors.append("ff00bf")
        colors.append("ff0080")
        colors.append("ff0040")
        colors.append("ff0000")
        return colors
    }
}
