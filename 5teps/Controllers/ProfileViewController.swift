//
//  ProfileViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextField!
    
    var user: User?
    var referenceForViewTop : Subview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Mentor top view settings ------------------------------------
        if let referenceForViewOnTheTop = Bundle.main.loadNibNamed("Subview", owner: self, options: nil)?.first as? Subview  {
            viewMentorTop.addSubview(referenceForViewOnTheTop)
            referenceForViewOnTheTop.frame.size.height = viewMentorTop.frame.size.height
            referenceForViewOnTheTop.frame.size.width = viewMentorTop.frame.size.width
            referenceForViewOnTheTop.subViewDelegate = self
            referenceForViewTop = referenceForViewOnTheTop
        }
        
        // MARK: update Mentor topview -------------------------------------------------------------
        referenceForViewTop?.backgroundColor = UIColor.gray
        //referenceForViewTop?.settingsMentor(imageName: "mentor", text: "Hello!")
        referenceForViewTop?.greetings(imageName: "mentor")
        //------------------------------------------------------------------

        self.profileImageView.image =  UIImage(named:"mentor")
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        user = User.userData
        
        nameTextView.text = user?.name
    }
    override func viewWillDisappear(_ animated: Bool) {
        user?.name = nameTextView.text
        user?.save()
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
            print("Topic: \(t.name!) \(t.bgColor)")
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

// MARK: Mentor SubviewDelegate
extension ProfileViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
    
}
