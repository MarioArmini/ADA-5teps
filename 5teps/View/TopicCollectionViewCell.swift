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
    
    var topic: Topic? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI() {
        //Card Layout
        viewCard.layer.cornerRadius = 20
        viewCard.clipsToBounds = true
        viewCard.backgroundColor = topic?.bgColor
        viewCard.layer.borderWidth = 2.0
        viewCard.layer.borderColor = UIColor.black.cgColor
        
        //self.topicIconView.backgroundColor = topic?.bgColor
        let w = self.topicIconView.layer.bounds.width
        let h = self.topicIconView.layer.bounds.height
        
        self.topicLabel.text = topic?.name
        self.topicIconView.image = UIImage.loadTopicIcon(name: topic?.icon ?? "", width: w, height: h, sizeFont: 80)
    }

}
