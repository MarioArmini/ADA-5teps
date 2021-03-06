//
//  NewChallengeViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 10/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class NewChallengeViewController: UIViewController {
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    
    var referenceForViewTop : Subview?
    public var topic: Topic?
    public var challenge: Challenge?
    public var parentVC: OnCloseChildView?
    var steps: [StepBase]!
    
    var gradientView: UIView?
    var gradientLayer: CAGradientLayer?
    var shadowLayer: CAShapeLayer?
    let cornerRadius: CGFloat = 20.20

    
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
        referenceForViewTop?.stepIndicationsInsideaChallenge(imageName: "mentorwithbubble")
        //------------------------------------------------------------------
        
        // Do any additional setup after loading the view.
        
        steps = [StepBase]()
        if self.challenge != nil {
            nameTextField.text = challenge?.name
            if let stepsChallenge = challenge?.stepsOrder {
                for stepChallenge in stepsChallenge {
                    let step = StepBase(step: stepChallenge)
                    
                    steps.append(step)
                }
            }
            
        }
        else {
            for i in 1...5 {
                let step = StepBase()
                step.step = i
                step.name = ""; //Step #\(i)"
                step.days = 1
                steps.append(step)
            }
        }
        setBackgroundCard()
        stepsCollectionView.delegate = self
        stepsCollectionView.dataSource = self
        stepsCollectionView?.backgroundColor = .clear
        stepsCollectionView?.decelerationRate = .fast
        
       
    }

    func setBackgroundCard()  {
        let rectFrame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        guard let color = topic?.colorCard else { return }
        
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
           
        /*
        let gradientLayer = CAGradientLayer()
        let gradientView = UIView(frame: rectFrame)
        cardView.insertSubview(gradientView, at: 0)
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = cardView.bounds
        
        cardView.layer.insertSublayer(gradientLayer, at: 1)
 */
    }

    @IBAction func onClickSave(_ sender: UIButton) {
        if nameTextField.text?.count == 0{
            Utils.showMessage(vc: self, title: NSLocalizedString("TITLE_SAVE", comment: ""), msg: NSLocalizedString("TITLE_INSERT_NAME_CHALLENGE", comment: ""))
            return
        }
        let cells = stepsCollectionView.visibleCells
        for cell in cells {
            if let stepCell = cell as? NewStepCollectionViewCell {
                stepCell.forceEndEditing()
            }
        }
        if self.challenge != nil {
            challenge?.name = nameTextField.text
            if let stepChallenge = challenge?.stepsOrder {
                for s in steps {
                    for step in stepChallenge {
                        if step.step == s.step {
                            step.name = s.name
                            step.days = Int16(s.days)
                            break
                        }
                    }
                }
                challenge?.save()
            }
            
        } else {
            let challenge = Challenge(context: SharedInfo.context)
            challenge.id = UUID()
            challenge.timestamp = Date()
            challenge.name = nameTextField.text
            challenge.currentStep = 0
            challenge.dateLast = Date()
            challenge.numberSteps = Int64(steps.count)
            challenge.state = ChallengeState.Create.rawValue
            challenge.topic = topic
            for s in steps {
                let step = StepChallenge(context: SharedInfo.context)
                step.id = UUID()
                step.name = s.name.count > 0 ? s.name : "Step #\(s.step)"
                step.timestamp = Date()
                step.state = StepChallengeState.Create.rawValue
                step.days = Int16(s.days)
                step.step = Int64(s.step)
                challenge.addToSteps(step)
            }
            
            challenge.save()
        }
        self.dismiss(animated: true) {
            self.parentVC?.onReloadDati()
        }
        //self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    override func viewDidLayoutSubviews() {
        gradientView?.frame = cardView.bounds
        gradientLayer?.frame = cardView.bounds
        shadowLayer?.path = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius).cgPath
        
    }
    
}
// MARK: Mentor SubviewDelegate
extension NewChallengeViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
extension NewChallengeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return steps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewStepCollectionViewCell else {
                return UICollectionViewCell()
        }
        cell.step = steps[indexPath.item]
        return cell
    }
}
