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
    
    var challenge: Challenge? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
