//
//  ChallengeCollectionViewCell.swift
//  5teps
//
//  Created by Mario Armini on 10/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var stepsImage: UIImageView!
    
    var topic: Topic? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(){
        self.contentView.backgroundColor = topic?.bgColor
    }
}
