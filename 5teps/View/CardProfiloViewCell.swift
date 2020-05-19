//
//  CardProfiloViewCell.swift
//  5teps
//
//  Created by Fabio Palladino on 19/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class CardProfiloViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var gradientLayer: CAGradientLayer?

    var challenge: Challenge? {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
           super.awakeFromNib()
           
    }
    func updateUI() {
        if let topic = challenge?.topic {
            //Card Layout
            contentView.layer.cornerRadius = 20.29
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
            gradientLayer?.frame = contentView.bounds
            
            contentView.layer.insertSublayer(gradientLayer!, at: 0)
        
        }
        nameLabel.text = challenge?.name
    }
}
