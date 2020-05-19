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
    var user: User?
    
    //greetings = welcome
    //MARK: Mentor Local sentences
    var greetings : [String] = ["Hello", "Salut", "Hola", "Hey!", "This is a great day to be productive!",  "Privet!", "Welcome!", "Hey there!", "I'm happy to see you! Can't wait to start!", "Hi! I'll be by your side during every challenge!" ]
    var motivation : [String] = ["Every challenge is possible if you write it in the right way!", "Every single step becomes a leap of faith", "Just reach up, don't give up", "I can't wait to see all the amazing things that you will achieve!", "Every step will take you a bit closer to your goal!", "Every step matter!"]
    
    //MARK: CHALLENGES
    
    //Incitazioni se nn ci sono challenge
    var noChallengeInProgress: [String] = ["Why don't you start a new challenge?", "Today is a great day to start a new challenge", "A new beginning: start your challenge today!", "What a great day to start a new challenge!", "Feeling bored? What about starting a new challenge?", "What about trying one of our challenges?", "Feeling productive? Try one of our challenge or create one yourself!", "Today is a great day to learn something new!", "If not now, when?"]
    //---------------------------------------------------------
    var challengeCompleted: [String] = ["Well done! Your reward is waiting for you in you profile section!", "Great Job! You deserved a reward, go in your profile section to find it out!", "I knew you would have smashed it! Your reward is waiting for you in your profile section!", "You did it! Your reward is waiting for you in you profile section!", "You did amazing!", "It has been amazing to guide you  through this challenge! ", "Your reward is waiting for you in you profile section!", "Congratulation! Your reward is waiting for you in your profile section!"]
    var challengeFailed: [String] = ["Oh no!", "Failing is just another part of the process, don't give up!", "Bad day happens, don't worry!", "I know you can do it, just try it again!", "I know you can do amazing things, keep trying!", "Don't worry, it's not the end, you can do it!", "Every failure is a lesson, just mae the best of it!", "It can happen, don't worry, I believe in you!"]
    
    //MARK: INDICATIONS + CAZZIATONE
    var stepIndications: [String] = ["In this section..."]
    var arrayCazziatone: [String] = []
    
    var mentorImages : [String] = ["mentor", "mentor1", "mentor2"]
    //MARK:  CHECKCHALLENGE 2 SECTION
    //----------------------------------------------------------
    
    
    var msgIndex = 0
    
    override func awakeFromNib() {
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = 40.0//imageView.frame.height/2
        imageView.clipsToBounds = true
        /*imageView.layer.cornerRadius = 20.0
         imageView.layer.masksToBounds = true
         imageView.clipsToBounds = true */
        
    }
    
    //MARK: CUSTOMIZE
    func settingsMentor(imageName: String, text: String) {
        imageView.image = UIImage(named: imageName)
        textView.text = text
        print("image: \(imageName), text: \(text)")
    }
    
    //MARK: GREETINGS [RANDOM]
    func greetingsMentor() {
        msgIndex = .random(in: 0...2)
        imageView.image = UIImage(named: mentorImages[msgIndex])
        
        let randomGreetings = Int(arc4random() % UInt32(greetings.count))
        user = User.userData
        if user?.name != nil {
            textView.text = "\(greetings[randomGreetings])  \(user!.name!)"
        }else{
            textView.text = "\(greetings[randomGreetings])"
        }
        let greet = textView
        print(greet!)
    }
    
    //MARK: MOTIVATION [RANDOM]
    func mentorMotivatesYou(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomMotivations = Int(arc4random() % UInt32(motivation.count))
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
