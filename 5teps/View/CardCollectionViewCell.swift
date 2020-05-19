//
//  CardCollectionViewCell.swift
//  5teps
//
//  Created by Fabio Palladino on 10/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var step1: UIImageView!
    @IBOutlet weak var step2: UIImageView!
    @IBOutlet weak var step3: UIImageView!
    @IBOutlet weak var step4: UIImageView!
    @IBOutlet weak var step5: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var gradientLayer: CAGradientLayer?

    
    var back: UIView!
    var front: UIView!
    
    var initNumber:Int = 0
    var flipped = true
    let cornerRadius: CGFloat = 20.29
    var challenge: Challenge? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        front = UIView(frame: contentView.frame)
        back = UIView(frame: contentView.frame)
        
        back.isHidden = !flipped
        
        //front.layer.borderWidth = 2.0
        //back.layer.borderWidth = 2.0
        
        let editButton = UIButton()
        let deleteButton = UIButton()
        
        
        editButton.frame = CGRect(x: viewCard.layer.bounds.width / 3 - 25, y: viewCard.layer.bounds.height / 2 - 30, width: 40, height: 40)
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.frame = CGRect(x: viewCard.layer.bounds.width - viewCard.layer.bounds.width / 3, y: viewCard.layer.bounds.height / 2 - 25, width: 40, height: 30)
        
        back.backgroundColor = UIColor.clear
        front.backgroundColor = UIColor.clear
        
        front.layer.cornerRadius = cornerRadius
        front.clipsToBounds = true
        //front.layer.borderWidth = 2.0
        
        back.layer.cornerRadius = cornerRadius
        back.clipsToBounds = true
        //back.layer.borderWidth = 2.0
        
        back.addSubview(deleteButton)
        back.addSubview(editButton)
        
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteChallenge), for: .touchUpInside)
        
        self.viewCard.addSubview(front)
        self.viewCard.addSubview(back)
        back.isHidden = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        let tap = UILongPressGestureRecognizer(target: self, action: #selector(flipCard))
        tap.numberOfTouchesRequired = 1
        tap.delaysTouchesEnded = true
        tap.minimumPressDuration = 0.5

        self.contentView.addGestureRecognizer(tap)
        self.contentView.isUserInteractionEnabled = true

    }
    
    @objc func edit(){
       let editNotification = Notification.Name("editNotification")
        NotificationCenter.default.post(name: editNotification, object: challenge)
    }
    
    @objc func deleteChallenge(){
        let deleteNotification = Notification.Name("deleteNotification")
        NotificationCenter.default.post(name: deleteNotification, object: challenge?.id)
        print("qui1")
    }
    
    @objc func flipCard(gesture:UIGestureRecognizer) {
        if gesture.state != .ended{
            let fromView = flipped ? front : back
            let toView = flipped ? back : front
            let flipDirection: UIView.AnimationOptions = flipped ? .transitionFlipFromRight : .transitionFlipFromLeft
            let options: UIView.AnimationOptions = [flipDirection, .showHideTransitionViews]
            UIView.transition(from: fromView!, to: toView!, duration: 0.6, options: options) {
                finished in
                self.flipped = !self.flipped
                print(self.flipped)
            }
        }
    }
    
    func updateUI() {
        var imageStep = [Int64:UIImageView]()
        imageStep[1] = step1
        imageStep[2] = step2
        imageStep[3] = step3
        imageStep[4] = step4
        imageStep[5] = step5
        
        
        viewCard.layer.cornerRadius = cornerRadius
        viewCard.clipsToBounds = true
        //viewCard.backgroundColor = challenge?.topic?.bgColor
        //viewCard.layer.borderWidth = 2.0
        //viewCard.layer.borderColor = UIColor.black.cgColor
        
        nameLabel.text = challenge?.name
        
        if let topic = challenge?.topic {
            //Card Layout
            contentView.layer.cornerRadius = cornerRadius
            contentView.clipsToBounds = true
            let color = topic.colorCard
            self.imageView.image = UIImage.loadTopicIcon(name: topic.icon ?? "")
            
            //print(topic?.name, color,topic?.color)
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
            gradientLayer?.colors = [color.uiColor1.cgColor, color.uiColor2.cgColor]
            gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer?.locations = [0, 1]
            gradientLayer?.frame = viewCard.bounds
            
            viewCard.layer.insertSublayer(gradientLayer!, at: 0)
        }
        if challenge != nil {
            let steps = challenge!.stepsOrder
            var maxStep: Int64 = 1
            for s in steps {
                var icon = "step-empty"
                if s.isFinish {
                    icon = "step-fill"
                }
                if imageStep.keys.contains(s.step) {
                    imageStep[s.step]?.image = UIImage(named: icon)
                    imageStep[s.step]?.isHidden = false
                }
                maxStep = (maxStep < s.step) ? s.step : maxStep
            }
            //Se sono meno di 5 step nascondo le immagini
            maxStep = maxStep + 1
            if maxStep < 5 {
                for i in maxStep...5 {
                    imageStep[i]?.isHidden = true
                }
            }
        }

    }
    
}
