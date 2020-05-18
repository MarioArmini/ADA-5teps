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
        viewCard.layer.cornerRadius = 20.29
        viewCard.clipsToBounds = true
        
        //self.topicIconView.backgroundColor = topic?.bgColor
        let w = self.topicIconView.layer.bounds.width
        let h = self.topicIconView.layer.bounds.height
        
        self.topicLabel.text = topic?.name
        self.topicIconView.image = UIImage.loadTopicIcon(name: topic?.icon ?? "", width: w, height: h, sizeFont: 80)
        
        if let color = topic?.colorCard {
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
    }

}
