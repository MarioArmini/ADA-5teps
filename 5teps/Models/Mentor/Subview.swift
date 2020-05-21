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
    var greetings : [String] = ["Hello", "Salut", "Hola", "Hey!", "This is a great day \nto be productive!",  "Privet!", "Welcome!", "Hey there!", "I'm happy to see you! \nCan't wait to start!", "Hi! I'll be by your side \nduring every challenge!\n" ]
    var motivation : [String] = ["Every challenge is possible if \nyou write it in the right way!", "Every single step becomes \na leap of faith", "Just reach up, \ndon't give up", "I can't wait to see all the \namazing things that you \nwill achieve!", "Every step will take you \na bit closer to your goal!", "Every step matter!"]
    
    //MARK: CHALLENGES
    
    //Incitazioni se nn ci sono challenge
    var noChallengeInProgress: [String] = ["Why don't you start \na new challenge?", "Today is a great day \nto start a new challenge", "A new beginning: \nstart your challenge today!", "What a great day \nto start a new challenge!", "Feeling bored? \nWhat about starting \na new challenge?", "What about trying \none of our challenges?", "Feeling productive? \nTry one of our challenge \nor create one yourself!", "Today is a great day \nto learn something new!", "If not now, when?"]
    //---------------------------------------------------------
    var challengeCompleted: [String] = ["Well done! \nYour reward is waiting for you \nin you profile section!", "Great Job! You deserved a reward, \ngo in your profile section \nto find it out!", "I knew you would have \nsmashed it! Your reward is waiting \nfor you in your profile section!", "You did it! \nYour reward is waiting for you \nin you profile section!", "You did amazing!", "It has been amazing to guide you \nthrough this challenge! ", "Your reward is waiting for you \nin you profile section!", "Congratulation! Your reward \nis waiting for you \nin your profile section!"]
    var challengeFailed: [String] = ["Oh no!", "Failing is just another part \nof the process, don't give up!", "Bad day happens, don't worry!", "I know you can do it, \njust try it again!", "I know you can do amazing things, \nkeep trying!", "Don't worry, it's not the end, \nyou can do it!", "Every failure is a lesson, \njust mae the best of it!", "It can happen, \ndon't worry, \nI believe in you!"]
    
    var stepCompleted : [String] = ["Great Job!", "Step Completed!", "Go, Go!", "Cool! This is \nyour next step"]
    
    var levelCompleted : [String] = ["Amazing! You've just \ncompleted your level"]
    
    //MARK: INDICATIONS + CAZZIATONE
    var stepIndications: [String] = ["In this section..."]
    var arrayCazziatone: [String] = ["Hey! What's wrong? \nYou can do more!", "You have to demonstrate \nyour commitment!", "Okay, You can do \nbetter than that!", "Come on, it's your \ntime to shine!\nDo more!", "If you don't try, you won't know!", "You'll never know what \nyou are capable of \nif you don't try"]
    
    var mentorImages : [String] = ["mentor", "mentor1", "mentor2"]
    
    var notificationIfChallengeIsInProgress = [String]()
    var notificationIfChallengeIsNotInProgress = [String]()
    
    
    //MARK:  CHECKCHALLENGE 2 SECTION
    //----------------------------------------------------------
    
    
    var msgIndex = 0
    
    override func awakeFromNib() {
        //imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        //imageView.layer.borderColor = UIColor.gray.cgColor
        //imageView.layer.cornerRadius = 40.0//imageView.frame.height/2
        //imageView.clipsToBounds = true
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
        imageView.image = UIImage(named: "mentorgreetings")
        
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
    
    
    func ifStepIsCompleted(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomStepCompleted = Int(arc4random() % UInt32(stepCompleted.count))
        textView.text = "\(stepCompleted[randomStepCompleted])"
        let stepComp = textView
        print(stepComp!)
    }
    
    func ifLevelIsCompleted(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomLevelCompleted = Int(arc4random() % UInt32(levelCompleted.count))
        textView.text = "\(levelCompleted[randomLevelCompleted])"
        let levelCom = textView
        print(levelCom!)
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
    
    public func backgroundChallengeInProgress(name: String, dayToLeft: Int, step: Int) -> (title: String, message: String) {
        var title = ""
        var message = ""
        
        title = "Forza devi completare la challenge"
        if dayToLeft == 0 {
            message = "E' scaduto il tempo forza forza per completare \(name)"
        } else if dayToLeft == 1 {
            message = "Ti mancano solo un giorno per completare \(name)"
        } else {
            message = "Ti mancano solo \(dayToLeft) giorni per completare \(name)"
        }
        
        return (title: title, message: message)
    }
    public func backgroundNoChallenge() -> (title: String, message: String) {
        var title = ""
        var message = ""
        
        title = "Start a challenge!!!"
        message = "Do something, start a challenge"
        
        return (title: title, message: message)
    }
    
    
    //MARK:  State Control
    
    func checkChallenge() {
        
        //array challenge in corso
        let challengeStarted = Challenge.listInProgress()
        if challengeStarted.count > 0 {
            //quotes
            mentorMotivatesYou(imageName: "mentorindicates")
        }else{
            //Why don't u start a new challenge?
            IfYouHaveNoChallenges(imageName: "mentorindicates")
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
