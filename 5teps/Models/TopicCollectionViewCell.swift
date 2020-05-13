//
//  TopicCollectionViewCell.swift
//  5teps
//
//  Created by Mario Armini on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var TopicLabel: UILabel!
    @IBOutlet weak var TopicIconView: UIImageView!
    
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
        self.TopicIconView.backgroundColor = topic?.bgColor
    }

}
