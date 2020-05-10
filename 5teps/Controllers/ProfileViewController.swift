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
    @IBOutlet weak var goalCollectionView: UICollectionView!
    
    var user: User?
    var referenceForViewTop : Subview?
    var goals: [Goal]!
    var sections: [Int:[Goal]]!
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
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
        
        sections = [Int:[Goal]]()
        goals = Goal.list()
        if goals.count == 0 {
            //TEST inserimento 10 Goals
            for i in 0...10 {
                let g = Goal(context: SharedInfo.context)
                g.id = UUID()
                g.date = Date()
                g.name = "Goal - \(i)"
                g.level = Int16(i + 1)
                goals.append(g)
            }
        }
        for j in 0...2 {
            sections[j] = [Goal]()
            for _ in 0...5 {
                let g = goals.remove(at: 0)
                sections[j]?.append(g)
                if goals.count == 0 {
                    break
                }
            }
            if goals.count == 0 {
                break
            }
        }
        goalCollectionView.delegate = self
        goalCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        user = User.userData
        
        nameTextView.text = user?.name
        
        goalCollectionView.reloadData()
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
    // MARK: - TEST FABIO
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
    @IBAction func onClickNewTopic(_ sender: Any) {
        let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newTopicView") as! NewTopicViewController
        //viewTmp.helpRequest = requestData
        self.navigationController?.pushViewController(viewTmp, animated: true)
    }
    @IBAction func onClickNewChallenge(_ sender: UIButton) {
        if let topic = Topic.findByName(name: "Hobby") {
            let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newChallengeView") as! NewChallengeViewController
            viewTmp.topic = topic
            self.navigationController?.pushViewController(viewTmp, animated: true)
        } else {
            Utils.showMessage(vc: self, title: "Attention", msg: "Hobby topic not found")
        }
        
    }
    
    // MARK: - ###############################################
}

// MARK: Mentor SubviewDelegate
extension ProfileViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMedal", for: indexPath) as! MedalCollectionViewCell
        //cell.contentView.backgroundColor = UIColor.red
        if let goal = sections[indexPath.section]?[indexPath.row] {
            cell.imageView.image = UIImage(named: "medal")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.layer.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
