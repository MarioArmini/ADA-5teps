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
extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func emojiToImage(width: CGFloat, height: CGFloat, sizeFont: CGFloat) -> UIImage? {
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set() // clear background
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: sizeFont)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    static func loadTopicIcon(name: String, width: CGFloat = 0, height: CGFloat = 0, sizeFont: CGFloat = 0) -> UIImage? {
        return UIImage(named: name)
        //return name.emojiToImage(width: width, height: height, sizeFont: sizeFont)
    }
}

extension UIView {
    
    func applyShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
}
