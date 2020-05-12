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
    @IBOutlet var stepView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var challengeCollectionView: UICollectionView!
    
    // single challenge
    @IBOutlet weak var titleChallengeLabel: UILabel!
    @IBOutlet weak var firstStepLabel: UILabel!
    @IBOutlet weak var secondStepLabel: UILabel!
    @IBOutlet weak var thirdStepLabel: UILabel!
    @IBOutlet weak var fourthStepLabel: UILabel!
    @IBOutlet weak var fifthStepLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    //provvisorio
    @IBOutlet weak var doneButton: UIButton!
    
    
    var referenceForViewTop : Subview?
    let defaults = UserDefaults.standard
    var topicName = String()
    var challenges = [Challenge]()
    var challengeTitle = String()
    var steps = [StepChallenge]()
    var isOpened = false
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var effect : UIVisualEffect!
    
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
        referenceForViewTop?.greetingsMentor()
        //------------------------------------------------------------------
        
        challengeCollectionView.register(UINib.init(nibName: "CardChallenge", bundle: nil), forCellWithReuseIdentifier: "cellCard")
        
        effect = blurEffect.effect
        blurEffect.effect = nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        challengeCollectionView.reloadData()
        
        topicName = defaults.string(forKey: "topicName") ?? ""
        if let topic = Topic.findByName(name: topicName) {
            challenges = topic.findChallengeByState(state: ChallengeState.Create)
        }
    }
    @IBAction func onClickNewChallenge(_ sender: Any) {
        if let topic = Topic.findByName(name: topicName) {
            let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newChallengeView") as! NewChallengeViewController
            viewTmp.topic = topic
            self.navigationController?.pushViewController(viewTmp, animated: true)
        } else {
            Utils.showMessage(vc: self, title: "Attention", msg: "Hobby topic not found")
        }
    }
    
    @IBAction func startChallenge(_ sender: Any) {
        if isOpened{
            for c in challenges{
                if c.name == titleChallengeLabel.text{
                    c.start()
                    animateOut()
                }
            }
        }
    }
    
    @IBAction func done(_ sender: Any) {
        animateOut()
    }
    
}


extension ChallengesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCard", for: indexPath) as! CardCollectionViewCell
        cell.nameLabel.text = String(challenges[indexPath.row].name ?? "")
        cell.challenge = challenges[indexPath.row]
        cell.isSelected = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.layer.bounds.width, height: 30)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        challengeTitle = challenges[indexPath.row].name ?? ""
        presentView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.layer.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * 1.25
        
        return CGSize(width: widthPerItem, height: heightPerItem)
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
    
    func presentView(){
        animateIn()
        
        self.titleChallengeLabel.text = challengeTitle
        for c in challenges{
            if c.name == challengeTitle{
                // funzione per lista steps
            }
        }
    }
    
    func animateIn(){
        self.view.addSubview(stepView)
        self.stepView.center = self.view.center
        
        self.stepView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.stepView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.blurEffect.effect = self.effect
            self.stepView.alpha = 1
            self.stepView.transform = CGAffineTransform.identity
        }
        
        isOpened = true
        self.blurEffect.isUserInteractionEnabled = true
        
    }
    
    func animateOut(){
        if isOpened{
            UIView.animate(withDuration: 0.3) {
                self.stepView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.stepView.alpha = 0
                
                self.blurEffect.effect = nil
                
                self.stepView.removeFromSuperview()
            }
        }
        isOpened = false
    }
    
}


// MARK: Mentor SubviewDelegate
extension ChallengesViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
    
}

