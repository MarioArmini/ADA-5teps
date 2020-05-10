//
//  Subview.swift
//  5teps
//
//  Created by Giusy Di Paola on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//


// MARK: THIS IS ALL ABOUT THE MENTOR.
import UIKit
import UserNotifications
protocol SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String)
    
}

class Subview: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    
    var subViewDelegate : SubviewDelegate!
    var challengeData = Challenge()
    
    //greetings = welcome
    //MARK: Mentor Local sentences
    var greetings : [String] = ["Hello", "Salut", "Hola", "Hey!", "This is a great day to be productive!"]
    var motivation : [String] = ["Just do it", "Every single step becomes a leap of faith", "Just reach up, don't give up"]
    
  //MARK: CHALLENGES
    var noChallengeInProgress: [String] = []
    var challengeCompleted: [String] = []
    var challengeFailed: [String] = []
    
//MARK: INDICATIONS + CAZZIATONE
    var stepIndications: [String] = []
    var arrayCazziatone: [String] = []
    
    var imagesMentor : [String] = []
    
//Second section: in progress
    var mentorIndicationSecondSection: [String] = []
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
    
    //MARK: MOTIVATION [RANDOM]
    func mentorMotivatesYou(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomMotivations = Int(arc4random() % UInt32(greetings.count))
        textView.text = "\(motivation[randomMotivations])"
        let motivate = textView
        print(motivate!)
    }
    
    func mentorMotivatesYouIfYouHaveNoChallenges(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomIncitazioni = Int(arc4random() % UInt32(greetings.count))
        textView.text = "\(noChallengeInProgress[randomIncitazioni])"
        let incitazioni = textView
        print(incitazioni!)
    }
    
    
    
    //----------------------------------------------
    
    
    
    
    func noChallengeAction() {
        // call to action
    }
    
    func checkChallenge() {
        //motivation
        
        //array challenge in corso
        let challengeStarted = Challenge.listInProgress()
        if challengeStarted.count > 0 {
            mentorMotivatesYou(imageName: "mentor")
        }else{
            mentorMotivatesYouIfYouHaveNoChallenges(imageName: "mentor")
        }
    }
    
    
    func challengeCompletedAction() {
        //var success
    }
    
    func localNotification(){
        /*let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let randomGreetings = Int(arc4random() % UInt32(greetings.count))
       
        
        content.title = "Your Mentor"
        content.body = "\(greetings[randomGreetings])"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "REMINDER", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
                
            }
        }*/
    }
    
}
