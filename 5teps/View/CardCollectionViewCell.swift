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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTouchesRequired = 1

        self.contentView.addGestureRecognizer(tap)
        self.contentView.isUserInteractionEnabled = true

    }
    @objc func tapped() {
        front = UIView(frame: viewCard.frame)
        back = UIView(frame: viewCard.frame)
        let editButton = UIButton()
        let deleteButton = UIButton()
        
        
        editButton.frame = CGRect(x: viewCard.layer.bounds.width / 3 - 30, y: viewCard.layer.bounds.height / 2 - 15, width: 30, height: 30)
        editButton.setTitle("edit", for: .normal)
        deleteButton.setTitle("delete", for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        deleteButton.frame = CGRect(x: viewCard.layer.bounds.width - viewCard.layer.bounds.width / 3 - 15, y: viewCard.layer.bounds.height / 2 - 15, width: 40, height: 30)
        
        
        back.backgroundColor = UIColor.green
        front.backgroundColor = UIColor.yellow
        
        front.layer.cornerRadius = 20
        front.clipsToBounds = true
        front.layer.borderWidth = 2.0
        
        back.layer.cornerRadius = 20
        back.clipsToBounds = true
        back.layer.borderWidth = 2.0
        
        back.addSubview(deleteButton)
        back.addSubview(editButton)
        
        viewCard.addSubview(front)

        if showingBack {
            NSLog("showBack")
            UIView.transition(from: back, to: front, duration: 1, options: UIView.AnimationOptions.transitionFlipFromLeft, completion: nil)
            showingBack = false
        } else {
            UIView.transition(from: front, to: back, duration: 1, options: UIView.AnimationOptions.transitionFlipFromRight, completion: nil)
            showingBack = true
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
