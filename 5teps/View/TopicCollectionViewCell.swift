//
//  TopicCollectionViewCell.swift
//  5teps
//
//  Created by Mario Armini on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var topicIconView: UIImageView!
    var gradientLayer: CAGradientLayer?
    var shadowLayer: CAShapeLayer?
    var colorCard: ColorCard?
    
    var back: UIView!
    var front: UIView!
    
    var initNumber:Int = 0
    var flipped = true
    let cornerRadius: CGFloat = 20.29
    
    var topic: Topic? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createFlipView()
    }
    func updateUI() {
        restoreFlipView()
        //Card Layout
        //viewCard.layer.cornerRadius = 20.29
        //viewCard.clipsToBounds = true
        //contentView.backgroundColor = UIColor.clear
        //contentView.layer.cornerRadius = cornerRadius
    
        
        //self.topicIconView.backgroundColor = topic?.bgColor
        let w = self.topicIconView.layer.bounds.width
        let h = self.topicIconView.layer.bounds.height
        
        self.topicLabel.text = topic?.name
        self.topicIconView.image = UIImage.loadTopicIcon(name: topic?.icon ?? "", width: w, height: h, sizeFont: 80)
        
        if let color = topic?.colorCard {
            colorCard = color
            //print(topic?.name, color,topic?.color)
            /*gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
            gradientLayer?.colors = [color.uiColor1.cgColor, color.uiColor2.cgColor]
            gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer?.locations = [0, 1]
            gradientLayer?.frame = viewCard.bounds
            
            viewCard.layer.insertSublayer(gradientLayer!, at: 0)
           */
            applyGradientShadow(color: color)
        }
    }
    func restoreFlipView() {
        flipped = true
        back?.isHidden = true
    }
    func createFlipView() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(flipCard))
        tap.numberOfTouchesRequired = 1
        tap.delaysTouchesEnded = true
        tap.minimumPressDuration = 0.5
        
        self.contentView.addGestureRecognizer(tap)
        self.contentView.isUserInteractionEnabled = true
        
        
        front = UIView(frame: contentView.frame)
        back = UIView(frame: contentView.frame)
        
        back.isHidden = !flipped
        
        //front.layer.borderWidth = 2.0
        //back.layer.borderWidth = 2.0
        
        let editButton = UIButton()
        let deleteButton = UIButton()
        
        
        editButton.frame = CGRect(x: 10, y: viewCard.layer.bounds.height / 2 - 30, width: 40, height: 40)
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.backgroundColor = UIColor(named: "blue")
        editButton.tintColor = UIColor.white
        editButton.layer.cornerRadius = 20
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.frame = CGRect(x: viewCard.layer.bounds.width - 50, y: viewCard.layer.bounds.height / 2 - 30, width: 40, height: 40)
        deleteButton.backgroundColor = UIColor(named: "blue")
        deleteButton.tintColor = UIColor.white
        deleteButton.layer.cornerRadius = 20
        
        back.backgroundColor = UIColor.clear
        front.backgroundColor = UIColor.clear
        
        front.layer.cornerRadius = cornerRadius
        front.clipsToBounds = true
        
        back.layer.cornerRadius = cornerRadius
        back.clipsToBounds = true
        
        back.addSubview(deleteButton)
        back.addSubview(editButton)
        
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteChallenge), for: .touchUpInside)
        
        self.viewCard.addSubview(front)
        self.viewCard.addSubview(back)
        back.isHidden = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.topAnchor.constraint(equalTo: self.viewCard.topAnchor, constant: 95).isActive = true
        editButton.leadingAnchor.constraint(equalTo: self.viewCard.leadingAnchor, constant: 10).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: self.viewCard.topAnchor, constant: 95).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.viewCard.trailingAnchor, constant: -10).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: editButton.widthAnchor).isActive = true
        
    }
    @objc func flipCard(gesture:UIGestureRecognizer) {
        if gesture.state != .ended{
            let fromView = flipped ? front : back
            let toView = flipped ? back : front
            let flipDirection: UIView.AnimationOptions = flipped ? .transitionFlipFromRight : .transitionFlipFromLeft
            let options: UIView.AnimationOptions = [flipDirection, .showHideTransitionViews]
            UIView.transition(from: fromView!, to: toView!, duration: 0.6, options: options) { finished in
                self.flipped = !self.flipped
            }
        }
    }
    @objc func edit() {
        if topic != nil {
            let editNotification = Notification.Name("editNotificationTopic")
            NotificationCenter.default.post(name: editNotification, object: topic!)
            restoreFlipView()
        }
        
    }
    @objc func deleteChallenge() {
        if topic != nil {
            let deleteNotification = Notification.Name("deleteNotificationTopic")
            NotificationCenter.default.post(name: deleteNotification, object: topic!.id)
            restoreFlipView()
        }
        
    }
    public func applyGradientShadow(color: ColorCard) {
        
        
        //let cornerRadius: CGFloat = 22
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [color.uiColor1.cgColor, color.uiColor2.cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer?.locations = [0, 1]
        gradientLayer?.frame = viewCard.bounds
        gradientLayer?.cornerRadius = cornerRadius
        
        viewCard.layer.insertSublayer(gradientLayer!, at: 0)
        /*
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = CAShapeLayer()
        
        let rect = CGRect(x: 10, y: 10, width: viewCard.bounds.width - 15, height: viewCard.bounds.height - 15)
        shadowLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        shadowLayer?.cornerRadius = cornerRadius
        shadowLayer?.applyShadow(color: UIColor.black, alpha: 0.50, x: 6, y: 5, blur: 15, spread: -13, path: nil)
        viewCard.layer.insertSublayer(shadowLayer!, at: 0)
 */
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if colorCard != nil {
            applyGradientShadow(color: colorCard!)
        }
    }
}
