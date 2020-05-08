//
//  Subview.swift
//  5teps
//
//  Created by Giusy Di Paola on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//


// MARK: THIS IS ALL ABOUT THE MENTOR.
import UIKit

protocol SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String)
    
}

class Subview: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    
    var subViewDelegate : SubviewDelegate!
    
    //MARK: Mentor Local sentences
    var greetings : [String] = ["Hello", "Salut", "Hola", "Hey!", "This is a great day to be productive!"]
    var motivation : [String] = ["Just do it", "Every single step becomes a leap of faith", "Just reach up, don't give up"]
    var success : [String] = []
    var failure: [String] = []
    
    var imagesMentor : [String] = []
    //----------------------------------------------------------
    
    var msgIndex = 0
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        
    }
    
    //MARK: CUSTOMIZE
    func settingsMentor(imageName: String, text: String) {
        imageView.image = UIImage(named: imageName)
        textView.text = text
        print("image: \(imageName), text: \(text)")
    }
    
    //MARK: GREETINGS [RANDOM]
    func greetings(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomGreetings = Int(arc4random() % UInt32(greetings.count))
        textView.text = "\(greetings[randomGreetings])"
        let greet = textView
        print(greet!)
    }
    
}
