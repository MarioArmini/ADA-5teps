//
//  InProgressViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 10/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class InProgressViewController: UIViewController{
    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var challengeCollectionView: UICollectionView!
    
    var referenceForViewTop : Subview?
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var sections: [Int: [Challenge]]!
    var dateSection: [String:Int]!
    
    var stepsView: StepsView!
    var challengeTitle = String()
    var effect = UIBlurEffect(style: .light)
    var blurEffect = UIVisualEffectView()
    var isOpened = false
    
    var row = Int()
    var section = Int()
    
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
        referenceForViewTop?.checkChallenge()
        //------------------------------------------------------------------
        
        challengeCollectionView.register(UINib.init(nibName: "CardChallenge", bundle: nil), forCellWithReuseIdentifier: "cellCard")
        
        stepsView = UINib(nibName: "StepsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? StepsView
        
        blurEffect.frame.size.height = self.view.frame.size.height
        blurEffect.frame.size.width = self.view.frame.size.width
        blurEffect.effect = nil
        self.view.addSubview(blurEffect)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTouchesRequired = 1
        
        blurEffect.addGestureRecognizer(tap)
        
        stepsView.layer.cornerRadius = 20
        
        challengeCollectionView.delegate = self
        challengeCollectionView.dataSource = self
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        let endNotification = Notification.Name("endNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(endChallenge), name: endNotification, object: nil)
        
        let nameNotification = Notification.Name("editNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(editClick), name: nameNotification, object: nil)
        
        let deleteNotification = Notification.Name("deleteNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteChallenge), name: deleteNotification, object: nil)
        
        reloadData()
    }
    func reloadData() {
        sections = [Int: [Challenge]]()
        dateSection = [String:Int]()
        let list = Challenge.listInProgress()
        
        var sectionMax = 0
        for c in list {
            //print(c.name, c.dateStart, )
            if let dateEnd = c.getCurrentStepChallenge()?.dateEnd  {
                if !dateSection.keys.contains(dateEnd.toString()) {
                    dateSection[dateEnd.toString()] = sectionMax
                    sections[sectionMax] = [Challenge]()
                    sectionMax = sectionMax + 1
                }
                if let s = dateSection[dateEnd.toString()] {
                    sections[s]?.append(c)
                }
            }
            
        }
        challengeCollectionView.reloadData()
    }
    
    @objc func tapped(){
        animateOut()
    }
    
    @objc func endChallenge(){
        let alert = UIAlertController(title: "Congratulations!", message: "You completed a challenge!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.animateOut()
            self.reloadData()
        })
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editClick(_ notification: Notification){
        let challengeReceived = notification.object as! Challenge
        let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newChallengeView") as! NewChallengeViewController
        viewTmp.topic = challengeReceived.topic
        viewTmp.challenge = challengeReceived
        viewTmp.parentVC = self
        self.present(viewTmp, animated: true) {
            
        }
        //self.navigationController?.pushViewController(viewTmp, animated: true)
    }
    @objc func deleteChallenge(_ notification: Notification){
        if let id = notification.object as? UUID {
            if let c = Challenge.findById(id: "\(id)") {
                let alert = UIAlertController(title: NSLocalizedString("TITLE_DELETE_ALERT", comment: ""), message: NSLocalizedString("MESSAGE_DELETE_ALERT", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    c.delete()
                    DispatchQueue.main.async {
                        
                    }
                    self.reloadData()
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL_ACTION", comment: ""), style: .cancel, handler: {action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}
// MARK: Mentor SubviewDelegate
extension InProgressViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
extension InProgressViewController : OnCloseChildView{
    func onReloadDati() {
        self.reloadData()
    }
}
extension InProgressViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section]?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.layer.bounds.width, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCard", for: indexPath) as! CardCollectionViewCell
        if let challenge = sections[indexPath.section]?[indexPath.row] {
            cell.challenge = challenge
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            //let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            // Customize footerView here
            //return footerView
        } else if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderProgressCollectionReusableView
            
            for k in dateSection {
                if k.value == indexPath.section {
                    headerView.headerLabel.text = k.key
                }
            }
            
            return headerView
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        challengeTitle = sections[indexPath.section]?[indexPath.row].name ?? ""
        row = indexPath.row
        section = indexPath.section
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
        let c = Challenge.findByName(name: challengeTitle)
        stepsView.challenge = c
        if c!.isStart{
            stepsView.startButton.alpha = 0
        }
        stepsView.backgroundColor = c!.topic?.bgColor
        stepsView.steps = c!.stepsOrder
        stepsView.label1.text = stepsView.steps[0].name
        stepsView.label2.text = stepsView.steps[1].name
        stepsView.label3.text = stepsView.steps[2].name
        stepsView.label4.text = stepsView.steps[3].name
        stepsView.label5.text = stepsView.steps[4].name
        stepsView.verifySteps()
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
            let indexPath = IndexPath(row: row, section: section)
            let cell = challengeCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
            cell.updateUI()
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
