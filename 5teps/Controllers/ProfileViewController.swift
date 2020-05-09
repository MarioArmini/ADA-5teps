//
//  ProfileViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onClickCaricaDatiJson(_ sender: Any) {
        //let json = ImportData.importJson()
        //print(json)
        
        //ImportData.saveTopic(topics: json)
        let topics = Topic.list()
        
        for t in topics {
            print("Topic: \(t.name!)")
            let challenges = t.findChallengeByState(state: ChallengeState.Create)
            for c in challenges {
                print("Challenge: \(c.name!) State:\(c.state)")
                for s in c.stepsOrder {
                    print("Step: \(s.step) - \(s.name!)")
                }
            }
            print("###########################################")
        }
    }
    @IBAction func onClickStart(_ sender: Any) {
        if let topic = Topic.findByName(name: "Hobby") {
            if let challenge = topic.findChallengeByName(name: "Impara il russo") {
                print("Challenge: \(challenge.name!) State:\(challenge.state) - \(String(describing: challenge.dateEnd))")
                if challenge.isCreate {
                    if challenge.start() {
                        
                    }
                }
                print("DeadLine challenge: \(challenge.deadLine!)")
                for s in challenge.stepsOrder {
                    print("Step: \(s.step) - \(s.name!) - \(String(describing: s.dateEnd))")
                }
            }
        }
        
    }
    
}
