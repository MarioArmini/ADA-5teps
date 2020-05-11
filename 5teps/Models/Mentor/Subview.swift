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
    
    //Incitazioni se nn ci sono challenge
    var noChallengeInProgress: [String] = ["Why don't you start a new challenge?", "Today is a great day to start a new challenge", "A new beginning: start your challenge today!"]
    //---------------------------------------------------------
    var challengeCompleted: [String] = ["Well done", "Great Job"]
    var challengeFailed: [String] = ["Oh no!"]
    
//MARK: INDICATIONS + CAZZIATONE
    var stepIndications: [String] = ["In this section..."]
    var arrayCazziatone: [String] = []
   

//MARK:  CHECKCHALLENGE 2 SECTION
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
    
    func IfYouHaveNoChallenges(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomIncitazioni = Int(arc4random() % UInt32(noChallengeInProgress.count))
        textView.text = "\(noChallengeInProgress[randomIncitazioni])"
        let incitazioni = textView
        print(incitazioni!)
    }
    
    func challengeCompletedAction(imageName: String) {
           //var challenge completed
        imageView.image = UIImage(named: imageName)
        let randomChallengeCompleted = Int(arc4random() % UInt32(challengeCompleted.count))
        textView.text = "\(challengeCompleted[randomChallengeCompleted])"
        let challengeComp = textView
        print(challengeComp!)
        
       }
    
    func ifTheChallengeIsFailed(imageName: String) {
        //var challenge completed
            imageView.image = UIImage(named: imageName)
            let randomChallengeFailed = Int(arc4random() % UInt32(challengeFailed.count))
            textView.text = "\(challengeFailed[randomChallengeFailed])"
            let challengeFail = textView
            print(challengeFail!)
    }
    
    func someStepIndications(imageName: String) {
        imageView.image = UIImage(named: imageName)
                   let randomSomeSteps = Int(arc4random() % UInt32(stepIndications.count))
                   textView.text = "\(stepIndications[randomSomeSteps])"
                   let someSteps = textView
                   print(someSteps!)
        
    }
    
    func mentorReproaches(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomMentorReproaches = Int(arc4random() % UInt32(arrayCazziatone.count))
        textView.text = "\(arrayCazziatone[randomMentorReproaches])"
        let someSteps = textView
        print(someSteps!)
    }
    //----------------------------------------------
    
    
    
     //MARK:  State Control
    
    func checkChallenge() {
     
        //array challenge in corso
        let challengeStarted = Challenge.listInProgress()
        if challengeStarted.count > 0 {
            //quotes
            mentorMotivatesYou(imageName: "mentor")
        }else{
            //Why don't u start a new challenge?
           IfYouHaveNoChallenges(imageName: "mentor")
        }
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
