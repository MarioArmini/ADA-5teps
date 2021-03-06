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

public struct ColorCard: Equatable{
    var color1: String
    var color2: String
    
    init(color1: String, color2: String) {
        self.color1 = color1
        self.color2 = color2
    }
    public var uiColor1: UIColor {
        return Utils.hexStringToUIColor(hex: self.color1)
    }
    public var uiColor2: UIColor {
        return Utils.hexStringToUIColor(hex: self.color2)
    }
    public static func == (lhs: ColorCard, rhs: ColorCard) -> Bool {
        return lhs.color2 == rhs.color2
    }
    public static var defaultColor: ColorCard {
        get {
            let colors = Utils.getArrayColor()
            return colors[0]
        }
    }
    public static func findColor(color: String) -> ColorCard {
        let colors = Utils.getArrayColor()
        if let i = colors.firstIndex(of: ColorCard(color1: color, color2: color)) {
            return colors[i]
        }
        return colors[0]
    }
}
public class Utils {
    
    static func showMessage(vc: UIViewController, title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true)
    }
    static func hexStringToUIColor (hex:String, alpha: CGFloat = 1.0) -> UIColor {
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
            alpha: alpha
        )
    }
    public static func getArrayIcon() -> [String] {
        var icons = [String]()
        /*
        for i in 0x1F601...0x1F64F {
            let c = String(UnicodeScalar(i)!)
            icons.append(c)
        }*/
        icons.append("cuoco")
        icons.append("camera")
        icons.append("libro")
        icons.append("mano")
        icons.append("musica")
        icons.append("notebook")
        icons.append("pianta")
        icons.append("sport")
        icons.append("tavolozza")
        return icons
    }
    public static func getArrayIconMedal() -> [String] {
        var icons = [String]()
        
        icons.append("medal1")
        icons.append("medal1")
        
        return icons
    }
    public static func getArrayColor() -> [ColorCard] {
        var colors = [ColorCard]()
        colors.append(ColorCard(color1: "FFDF88", color2: "FFC859"))
        colors.append(ColorCard(color1: "DCFF81", color2: "BBE846"))
        colors.append(ColorCard(color1: "86FAB8", color2: "4DDA8A"))
        colors.append(ColorCard(color1: "BED5FF", color2: "89B2FD"))
        colors.append(ColorCard(color1: "A2C8F0", color2: "4AA1FF"))
        colors.append(ColorCard(color1: "FFA183", color2: "F77F57"))
        colors.append(ColorCard(color1: "FFABFB", color2: "E352DC"))
        colors.append(ColorCard(color1: "AEA7FD", color2: "7569FF"))
        colors.append(ColorCard(color1: "FAC1CF", color2: "FF9BB4"))
        return colors
    }
    public static func addGradient(imageBackground: UIView, color1: UIColor, color2: UIColor) -> UIView {
        let rectFrame = CGRect(x: 0, y: 0, width: imageBackground.frame.width, height: imageBackground.frame.height)
        let grayView = UIView(frame: rectFrame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = imageBackground.bounds
        
        imageBackground.insertSubview(grayView, at: 0)
        grayView.layer.insertSublayer(gradientLayer, at: UInt32(imageBackground.layer.sublayers?.count ?? 0))
        
        return grayView
    }
    public static func stringToDate(string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        return dateFormatter.date(from: string)
    }
    public static func dateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    public static func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
