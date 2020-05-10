//
//  ChallengesViewController.swift
//  5teps
//
//  Created by Mario Armini on 10/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {
    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var challengeCollectionView: UICollectionView!
    var referenceForViewTop : Subview?
    let defaults = UserDefaults.standard
    let topics = Topic.list()
    var topicName = String()
    var challenges = [Challenge]()

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        challengeCollectionView.reloadData()
        
        topicName = defaults.string(forKey: "topicName") ?? ""
        for t in topics{
            if t.name == topicName{
                challenges = t.findChallengeByState(state: ChallengeState.Create)
            }
        }
    }

}

extension ChallengesViewController: UICollectionViewDelegate{
    
}

extension ChallengesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCell", for: indexPath) as! ChallengeCollectionViewCell
        cell.challengeLabel.text = String(challenges[indexPath.row].name ?? "")
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if challenges.count < 4{
            return 2
        }
        return challenges.count / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 245)
    }
    
}


// MARK: Mentor SubviewDelegate
extension ChallengesViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
    
}

