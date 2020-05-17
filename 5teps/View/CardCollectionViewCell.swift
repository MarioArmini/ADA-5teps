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
    
    var back: UIView!
    var front: UIView!
    var showingBack = true
    var initNumber:Int = 0
    
    
    var challenge: Challenge? {
        didSet {
            updateUI()
        }
    }
    
    var flipped = false
    
    /*override func prepareForReuse() {
        super.prepareForReuse()
        front = nil
        flipped = false
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        front = UIView(frame: contentView.frame)
        back = UIView(frame: contentView.frame)
        
        back.isHidden = !flipped
        
        front.layer.borderWidth = 2.0
        back.layer.borderWidth = 2.0
        
        let editButton = UIButton()
        let deleteButton = UIButton()
        
        
        editButton.frame = CGRect(x: viewCard.layer.bounds.width / 3 - 30, y: viewCard.layer.bounds.height / 2 - 30, width: 40, height: 40)
        editButton.setTitle("edit", for: .normal)
        deleteButton.setTitle("delete", for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        deleteButton.frame = CGRect(x: viewCard.layer.bounds.width - viewCard.layer.bounds.width / 3 - 15, y: viewCard.layer.bounds.height / 2 - 25, width: 40, height: 30)
        
        
        back.backgroundColor = UIColor.green
        front.backgroundColor = UIColor.clear
        
        front.layer.cornerRadius = 20
        front.clipsToBounds = true
        front.layer.borderWidth = 2.0
        
        back.layer.cornerRadius = 20
        back.clipsToBounds = true
        back.layer.borderWidth = 2.0
        
        back.addSubview(deleteButton)
        back.addSubview(editButton)
        
        self.viewCard.addSubview(front)
        self.viewCard.addSubview(back)
        
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
    
    @objc func flipCard(gesture:UIGestureRecognizer) {
        if gesture.state != .ended{
            let fromView = flipped ? front : back
            let toView = flipped ? back : front
            let flipDirection: UIView.AnimationOptions = flipped ? .transitionFlipFromRight : .transitionFlipFromLeft
            let options: UIView.AnimationOptions = [flipDirection, .showHideTransitionViews]
            UIView.transition(from: fromView!, to: toView!, duration: 0.6, options: options) {
                finished in
                self.flipped = !self.flipped
            }
        }
    }
    
    func updateUI() {
        viewCard.layer.cornerRadius = 20
        viewCard.clipsToBounds = true
        viewCard.backgroundColor = challenge?.topic?.bgColor
        viewCard.layer.borderWidth = 2.0
        viewCard.layer.borderColor = UIColor.black.cgColor
        
        nameLabel.text = challenge?.name
    }
    
}
