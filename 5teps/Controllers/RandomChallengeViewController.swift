//
//  RandomChallengeViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 23/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class RandomChallengeViewController: UIViewController {
    
    @IBOutlet weak var viewMentorTop: UIView!
    var referenceForViewTop : Subview?
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardStartButton: UIButton!
    
    public var parentVC: OnCloseChildView?
    public var challenge: Challenge?
    var gradientView: UIView?
    var gradientLayer: CAGradientLayer?
    var shadowLayer: CAShapeLayer?
    let cornerRadius: CGFloat = 20.20
    var colorCard: ColorCard = ColorCard.defaultColor
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Mentor top view settings ------------------------------------
        if let referenceForViewOnTheTop = Bundle.main.loadNibNamed("Subview", owner: self, options: nil)?.first as? Subview  {
            viewMentorTop.addSubview(referenceForViewOnTheTop)
            referenceForViewOnTheTop.frame.size.height = viewMentorTop.frame.size.height
            referenceForViewOnTheTop.frame.size.width = viewMentorTop.frame.size.width
            referenceForViewOnTheTop.subViewDelegate = self
            referenceForViewTop = referenceForViewOnTheTop
        }
        
        // MARK: update Mentor topview -------------------------------------------------------------
        referenceForViewTop?.randomShakingChallenge()
        //------------------------------------------------------------------
    
        let list = Challenge.listByState(state: .Create)
        
        if list.count > 0 {
            challenge = list[Int.random(in: 0..<list.count)]
            colorCard = challenge?.topic?.colorCard ?? colorCard
            cardNameLabel.text = challenge?.name
            if let topic = challenge?.topic {
                cardImage.image = UIImage.loadTopicIcon(name: topic.icon ?? "")
            }
            setBackgroundCard()
        } else {
            cardStartButton.isHidden = true
            cardNameLabel.text = "No Challange Available"
        }
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundCard()
    }
    func setBackgroundCard() {
        let rectFrame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        let color = self.colorCard
        
        //cardView.layer.cornerRadius = 20.20
        //cardView.clipsToBounds = true
        cardView.backgroundColor = UIColor.clear
        
        let color1 = Utils.hexStringToUIColor(hex: color.color1)
        let color2 = Utils.hexStringToUIColor(hex: color.color2)
        
        if gradientView == nil {
            gradientView = UIView(frame: rectFrame)
            cardView.insertSubview(gradientView!, at: 0)
        }
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [color1.cgColor, color2.cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer?.locations = [0, 1]
        gradientLayer?.frame = gradientView!.bounds
        gradientLayer?.cornerRadius = cornerRadius
        
        gradientView?.layer.insertSublayer(gradientLayer!, at: 0)
        
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = CAShapeLayer()
        
        // let rect = CGRect(x: 15, y: 15, width: (gradientView?.bounds.width)! - 35, height: gradientView?.bounds.height - 35)
        shadowLayer?.path = UIBezierPath(roundedRect: gradientView!.bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer?.cornerRadius = cornerRadius
        shadowLayer?.applyShadow(color: UIColor.black, alpha: 0.50, x: 6, y: 5, blur: 50, spread: -13, path: nil)
        gradientView?.layer.insertSublayer(shadowLayer!, at: 0)
        
    }
    override func viewDidLayoutSubviews() {
        gradientView?.frame = cardView.bounds
        gradientLayer?.frame = cardView.bounds
        shadowLayer?.path = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius).cgPath
        
    }
    @IBAction func onClickStart(_ sender: Any) {
        if challenge != nil {
            let _ = challenge?.start()
            self.dismiss(animated: true) {
                self.parentVC?.onOpenChallengeView(topic: self.challenge!.topic!)
            }
        }
    }
}
extension RandomChallengeViewController: SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
