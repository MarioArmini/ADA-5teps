//
//  NewTopicCollectionViewCell.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class NewTopicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white
            //self.imageView.alpha = isSelected ? 0.75 : 1.0
        }
    }
}
