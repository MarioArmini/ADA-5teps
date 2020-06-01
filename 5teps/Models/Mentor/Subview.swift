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
    
    //MARK: Mentor Local sentences
    var greetings : [String]!
    //MARK: Mentor Local Motivations
    var motivation : [String]!
    
    //MARK: CHALLENGES
    //MARK: Mentor motivates you if you have no challenges
    //Incitazioni se nn ci sono challenge
    var noChallengeInProgress: [String]!
    //---------------------------------------------------------
    //MARK: [Mentor] when a challenge is completed
    var challengeCompleted: [String]!
    //MARK: [Mentor] when a challenge is failed
    var challengeFailed: [String]!
    //MARK: [Mentor] when a step is completed
    var stepCompleted : [String]!
    //MARK: [Mentor] when a a level is completed
    var levelCompleted : [String]!
    
    
    //MARK: INDICATIONS + CAZZIATONE
    //MARK: when an user creates a new card. Some indications are useful
    var stepIndications: [String]!
    var arrayCazziatone: [String]!
    
    var indicationsAddNewCardInsideaChallenge : String = "Insert your card's name, \nset your steps and days."
    
    var mentorImages : [String]!
    var randomChallenge: String = "This is your \nrandom challenge!"
    var notificationIfChallengeIsInProgress = [String]()
    var notificationIfChallengeIsNotInProgress = [String]()
    
    
    
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
        self.importJson()
    }
    func importJson() {
        
        let nameJson =  NSLocalizedString("JSON_FILE_MENTOR", comment: "")
        if let pathFile = Bundle.main.path(forResource: nameJson, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: pathFile), options: .mappedIfSafe)
               
                let decoder = JSONDecoder()
                let json = try decoder.decode(JsonMentor.self, from: jsonData)
                
                self.greetings = json.greetings
                self.motivation = json.motivation   
                self.noChallengeInProgress = json.noChallengeInProgress
                self.challengeCompleted = json.challengeCompleted
                self.challengeFailed = json.challengeFailed
                self.stepCompleted = json.stepCompleted
                self.levelCompleted = json.levelCompleted
                self.stepIndications = json.stepIndications
                self.arrayCazziatone = json.arrayCazziatone
                self.mentorImages = json.mentorImages
            } catch {
                print("Error importJson: \(error.localizedDescription)")
            }
        } else {
            print("file non found")
        }
    }
    //MARK: CUSTOMIZE THE MENTOR
    func settingsMentor(imageName: String, text: String) {
        imageView.image = UIImage(named: imageName)
        textView.text = text
        print("image: \(imageName), text: \(text)")
    }
    
    //MARK: GREETINGS [RANDOM]
    func greetingsMentor() {
        msgIndex = .random(in: 0...2)
        imageView.image = UIImage(named: "mentorwithbubble")
        
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
    // MARK: if you have no challenges.
    func IfYouHaveNoChallenges(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomIncitazioni = Int(arc4random() % UInt32(noChallengeInProgress.count))
        textView.text = "\(noChallengeInProgress[randomIncitazioni])"
        let incitazioni = textView
        print(incitazioni!)
    }
    // MARK: is a challenge is completed
    func challengeCompletedAction(imageName: String) {
        //var challenge completed
        imageView.image = UIImage(named: imageName)
        let randomChallengeCompleted = Int(arc4random() % UInt32(challengeCompleted.count))
        textView.text = "\(challengeCompleted[randomChallengeCompleted])"
        let challengeComp = textView
        print(challengeComp!)
    }
    
    // MARK: if a step is completed
    func ifStepIsCompleted(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomStepCompleted = Int(arc4random() % UInt32(stepCompleted.count))
        textView.text = "\(stepCompleted[randomStepCompleted])"
        let stepComp = textView
        print(stepComp!)
    }
    // MARK: if the level is achieved.
    func ifLevelIsCompleted(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomLevelCompleted = Int(arc4random() % UInt32(levelCompleted.count))
        textView.text = "\(levelCompleted[randomLevelCompleted])"
        let levelCom = textView
        print(levelCom!)
    }
    
    func randomShakingChallenge() {
        imageView.image = UIImage(named: "mentorwithbubble")
        user = User.userData
        if user?.name != nil {
            textView.text = "\(user!.name!) \(randomChallenge)"
        }else{
            textView.text = "\(randomChallenge)"
        }
        
        
       
    }
    
    
    // MARK: if your challenge is failed
    func ifTheChallengeIsFailed(imageName: String) {
        //var challenge completed
        imageView.image = UIImage(named: imageName)
        let randomChallengeFailed = Int(arc4random() % UInt32(challengeFailed.count))
        textView.text = "\(challengeFailed[randomChallengeFailed])"
        let challengeFail = textView
        print(challengeFail!)
    }
    
    // MARK: Step indications when a card is created
    func someStepIndications(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomSomeSteps = Int(arc4random() % UInt32(stepIndications.count))
        user = User.userData
        if user?.name != nil {
            textView.text = "\(stepIndications[randomSomeSteps]) \(user!.name!)"
        }else{
            textView.text = "\(stepIndications[randomSomeSteps])"
        }
        let someSteps = textView
        print(someSteps!)
    }
    // MARK: Mentor reproaches the user
    func mentorReproaches(imageName: String) {
        imageView.image = UIImage(named: imageName)
        let randomMentorReproaches = Int(arc4random() % UInt32(arrayCazziatone.count))
        textView.text = "\(arrayCazziatone[randomMentorReproaches])"
        let someSteps = textView
        print(someSteps!)
    }
    
    func stepIndicationsInsideaChallenge(imageName: String){
        imageView.image = UIImage(named: imageName)
        
        user = User.userData
        if user?.name != nil {
            textView.text = "\(indicationsAddNewCardInsideaChallenge) \(user!.name!)"
        }else{
            textView.text = "\(indicationsAddNewCardInsideaChallenge)"
        }
        
        
        let indicationsChallenge = textView
        print(indicationsChallenge!)
    }
    
    //----------------------------------------------
    
    public func backgroundChallengeInProgress(name: String, dayToLeft: Int, step: Int) -> (title: String, message: String) {
        var title = ""
        var message = ""
        
        title = "Come on, you have to achieve your goals!"
        if dayToLeft == 0 {
            message = " Your time is up!!! Come on, complete your challenge! \(name)"
        } else if dayToLeft == 1 {
            message = "One day left! \(name)"
        } else {
            message = "Days left \(dayToLeft) to complete your challenge! \(name)"
        }
        
        return (title: title, message: message)
    }
    public func backgroundNoChallenge() -> (title: String, message: String) {
        var title = ""
        var message = ""
        
        title = "Oscar - Your Mentor"
        message = "Today is a great day to start a challenge!"
        
        return (title: title, message: message)
    }
    
    
    //MARK:  State Control to check if a challenge is in progress or not.
    
    func checkChallenge() {
        
        //array challenge in corso
        let challengeStarted = Challenge.listInProgress()
        if challengeStarted.count > 0 {
            //quotes
            mentorMotivatesYou(imageName: "mentorwithbubble")
        }else{
            //Why don't u start a new challenge?
            IfYouHaveNoChallenges(imageName: "mentorwithbubble")
        }
    }
    
    
    // A topic has been created, Oscar should say something in the "Challenges" Section:
    
    func feedbackSimone() {
        imageView.image = UIImage(named: "mentorwithbubble")
        textView.text = "Great! Please, click on the Add button \nto create your new challenge now"
    }
    
    
    
    //MARK: Scheduled local notifications.
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
        //test
    }
    
}

struct JsonMentor: Codable {
    var greetings: [String]
    var motivation: [String]
    var noChallengeInProgress: [String]
    var challengeCompleted: [String]
    var challengeFailed: [String]
    var stepCompleted: [String]
    var levelCompleted: [String]
    var stepIndications: [String]
    var arrayCazziatone: [String]
    var mentorImages: [String]
}
