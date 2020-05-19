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
    var stepsView: StepsView!
    var effect = UIBlurEffect(style: .light)
    var blurEffect = UIVisualEffectView()
    
    var referenceForViewTop : Subview?
    let defaults = UserDefaults.standard
    var topicName = String()
    var challenges = [Challenge]()
    var challengeTitle = String()
    var steps = [StepChallenge]()
    var isOpened = false
    var challengeSections = [Int: [Challenge]]()
    //public var id: UUID!
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // MARK: Mentor top view settings ------------------------------------
        if let referenceForViewOnTheTop = Bundle.main.loadNibNamed("Subview", owner: self, options: nil)?.first as? Subview  {
            viewMentorTop.addSubview(referenceForViewOnTheTop)
            referenceForViewOnTheTop.frame.size.height = viewMentorTop.frame.size.height
            referenceForViewOnTheTop.frame.size.width = viewMentorTop.frame.size.width
            referenceForViewOnTheTop.subViewDelegate = self
            referenceForViewTop = referenceForViewOnTheTop
        }
        
        // MARK: update Mentor topview -------------------------------------------------------------
       
        //referenceForViewTop?.settingsMentor(imageName: "mentor", text: "Hello!")
        referenceForViewTop?.greetingsMentor()
        //------------------------------------------------------------------
        
        stepsView = UINib(nibName: "StepsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? StepsView
        
        challengeCollectionView.register(UINib.init(nibName: "CardChallenge", bundle: nil), forCellWithReuseIdentifier: "cellCard")
        
        
        blurEffect.frame.size.height = self.view.frame.size.height
        blurEffect.frame.size.width = self.view.frame.size.width
        blurEffect.effect = nil
        self.view.addSubview(blurEffect)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTouchesRequired = 1

        blurEffect.addGestureRecognizer(tap)
        
        stepsView.layer.cornerRadius = 20
        
        let deleteNotification = Notification.Name("deleteNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteChallenge), name: deleteNotification, object: nil)
        
        let nameNotification = Notification.Name("editNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(editClick), name: nameNotification, object: nil)
               
        
        
        
    }
    
    @objc func deleteChallenge(_ notification: Notification){
        if let id = notification.object as? UUID {
            if let c = Challenge.findById(id: "\(id)") {
                let alert = UIAlertController(title: "Attention", message: "Do you want to delete this challenge?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    c.delete()
                    DispatchQueue.main.async {
                        
                    }
                    self.reloadData()
                    }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    @objc func editClick(_ notification: Notification){
        let challengeReceived = notification.object as! Challenge
        let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newChallengeView") as! NewChallengeViewController
        viewTmp.topic = challengeReceived.topic
        viewTmp.challenge = challengeReceived
        self.navigationController?.pushViewController(viewTmp, animated: true)
    }
    
    @objc func tapped(){
        animateOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
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
    func reloadData() {
        topicName = defaults.string(forKey: "topicName") ?? ""
        if let topic = Topic.findByName(name: topicName) {
            challenges = topic.findChallengeByState(state: ChallengeState.Create, state2: ChallengeState.Started)
        }
        challengeSections[0] = challenges
        /*if challenges.count % 4 > 0{
            var section = 0
            let maxSections = challenges.count / 4 + 1
            var breakPoint = 3
            let end = challenges.count
            var j = -1
            for i in 0...end{
                if !challengeSections.keys.contains(section) {
                    challengeSections[section] = [Challenge]()
                }
                j = j + 1
                if j >= end{
                    break
                }
                challengeSections[section]?.append(challenges[j])
                if i == breakPoint{
                    breakPoint = breakPoint + 4
                    section = section + 1
                    if section == maxSections{
                        break
                    }
                }
            }
        }*/
        challengeCollectionView.reloadData()
        
    }
}


extension ChallengesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCard", for: indexPath) as! CardCollectionViewCell
        cell.nameLabel.text = String(challengeSections[indexPath.section]?[indexPath.row].name ?? "")
        cell.challenge = challengeSections[indexPath.section]?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.layer.bounds.width, height: 30)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if challenges.count % 4 > 0{
            return challenges.count / 4 + 1
        }
        else if challenges.count % 4 == 0{
            return challenges.count / 4
        }
        return challenges.count / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeSections[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        challengeTitle = challengeSections[indexPath.section]?[indexPath.row].name ?? ""
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
        stepsView.titleLabel.text = challengeTitle
        for c in self.challenges{
            if c.name == challengeTitle{
                stepsView.challenge = c
                if c.isStart{
                    stepsView.startButton.alpha = 0
                }
                stepsView.backgroundColor = c.topic?.bgColor
                stepsView.steps = c.stepsOrder
                stepsView.label1.text = stepsView.steps[0].name
                stepsView.label2.text = stepsView.steps[1].name
                stepsView.label3.text = stepsView.steps[2].name
                stepsView.label4.text = stepsView.steps[3].name
                stepsView.label5.text = stepsView.steps[4].name
            }
        }
    }
    
    func animateIn(){
        self.view.addSubview(stepsView)
        stepsView.center = self.view.center
        
        stepsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        stepsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.blurEffect.effect = self.effect
            self.stepsView.alpha = 1
            self.stepsView.transform = CGAffineTransform.identity
        }
        
        isOpened = true
        self.blurEffect.isUserInteractionEnabled = true
        
    }
    
    func animateOut(){
        if isOpened{
            UIView.animate(withDuration: 0.3) {
                self.stepsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.stepsView.alpha = 0
                
                self.blurEffect.effect = nil
                
                self.stepsView.removeFromSuperview()
            }
        }
        self.blurEffect.isUserInteractionEnabled = false
        isOpened = false
    }
    
}


// MARK: Mentor SubviewDelegate
extension ChallengesViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
    
}

