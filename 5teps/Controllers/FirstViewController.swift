//
//  FirstViewController.swift
//  5teps
//
//  Created by Mario Armini on 07/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var TopicCollectionView: UICollectionView!
    var referenceForViewTop : Subview?
    let topics = Topic.list()
    let defaults = UserDefaults.standard
    
    
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
        
        // MARK: load default data from json
        let topics = Topic.list()
        if topics.count == 0 {
            let json = ImportData.importJson()
            ImportData.saveTopic(topics: json)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        TopicCollectionView.reloadData()
       /* topicLabelTest.text = ""
        let topics = Topic.list()
        for topic in topics {
            print(topic)
            topicLabelTest.text = topicLabelTest.text! + "\n \(String(describing: topic.name)) - \(String(describing: topic.icon))"
        }
        // MARK: Esempio di navigazione oggetti Topic -> Challenge -> Step
        
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
         */
    }
}

extension FirstViewController: UICollectionViewDelegate{
    
}

extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicCollectionViewCell
        cell.TopicLabel.text = self.topics[indexPath.section].name
        //cell.TopicIconView.image = topics[indexPath.section].icon?.emojiToImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: 373, height: 528)
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defaults.set(topics[indexPath.section].name, forKey: "topicName")
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
}

// MARK: Mentor SubviewDelegate
extension FirstViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
    
}
