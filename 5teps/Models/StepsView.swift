//
//  StepsView.swift
//  5teps
//
//  Created by Mario Armini on 19/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class StepsView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var deadlineLabel1: UILabel!
    @IBOutlet weak var deadlineLabel2: UILabel!
    @IBOutlet weak var deadlineLabel3: UILabel!
    @IBOutlet weak var deadlineLabel4: UILabel!
    @IBOutlet weak var deadlineLabel5: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    var steps = [StepChallenge]()
    let labelCompleted = ""
    var challenge: Challenge! {
        didSet {
            self.steps = challenge.stepsOrder
            updateUI()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func updateUI() {
        self.deadlineLabel1.text = ""
        self.deadlineLabel2.text = ""
        self.deadlineLabel3.text = ""
        self.deadlineLabel4.text = ""
        self.deadlineLabel5.text = ""
        self.button1.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        self.button2.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        self.button3.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        self.button4.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        self.button5.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        
        label1.text = steps[0].name
        label2.text = steps[1].name
        label3.text = steps[2].name
        label4.text = steps[3].name
        label5.text = steps[4].name
        
        self.startButton.isHidden = !challenge.isCreate
        self.startButton.setTitle(NSLocalizedString("TITLE_START_BUTTON", comment: ""), for: .normal)
        
        self.backgroundColor = challenge.topic?.bgColor
        verifySteps()
        for i in 0..<5 {
            var enable = true
            if self.steps[i].isCreate || self.steps[i].isFinish {
                enable = false
            }
            switch(i) {
            case 0:
                self.button1.isEnabled = enable
                break;
            case 1:
                self.button2.isEnabled = enable
                break;
            case 2:
                self.button3.isEnabled = enable
                break;
            case 3:
                self.button4.isEnabled = enable
                break;
            case 4:
                self.button5.isEnabled = enable
                break;
            default:
                break;
            }
        }
    }
    func verifySteps(){
        if self.steps[0].isFinish{
            self.button1.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button1.center, toPoint: self.button2.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel1.text = labelCompleted
            let deadline = steps[1].daysToDeadline()
            if deadline == 1{
                self.deadlineLabel2.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
            }
            else{
                self.deadlineLabel2.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
            }
        }
        else if !self.steps[0].isFinish {
            self.button1.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel1.text = ""
            
        }
        
        if self.steps[1].isFinish{
            self.button2.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button2.center, toPoint: self.button3.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel2.text = labelCompleted
            let deadline = steps[2].daysToDeadline()
            if deadline == 1{
                self.deadlineLabel3.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
            }
            else{
                self.deadlineLabel3.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
            }
        }
        else if !self.steps[1].isFinish{
            self.button2.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel2.text = ""
        }
        
        if self.steps[2].isFinish{
            self.button3.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button3.center, toPoint: self.button4.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel3.text = labelCompleted
            let deadline = steps[3].daysToDeadline()
            if deadline == 1{
                self.deadlineLabel4.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
            }
            else{
                self.deadlineLabel4.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
            }
        }
        else if !self.steps[2].isFinish{
            self.button3.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel3.text = ""
        }
        
        if self.steps[3].isFinish{
            self.button4.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button4.center, toPoint: self.button5.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel4.text = labelCompleted
            let deadline = steps[4].daysToDeadline()
            if deadline == 1{
                self.deadlineLabel5.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
            }
            else{
                self.deadlineLabel5.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
            }
        }
        else if !self.steps[3].isFinish{
            self.button4.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel4.text = ""
        }
        
        if self.steps[4].isFinish {
            self.button5.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.deadlineLabel5.text = labelCompleted
        }
        else if !self.steps[4].isFinish {
            self.button5.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel5.text = ""
        }
        if let c = challenge {
            if c.currentStep > 0 && c.currentStep <= Challenge.DEFAULT_STEPS {
                let step = steps[Int(c.currentStep) - 1]
                let deadline = step.daysToDeadline()
                switch(c.currentStep) {
                case 1:
                    if deadline == 1 {
                        self.deadlineLabel1.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAY", comment: "")
                    }
                    else{
                        self.deadlineLabel1.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAYS", comment: "")
                    }
                    break;
                case 2:
                    if deadline == 1 {
                        self.deadlineLabel2.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAY", comment: "")
                    }
                    else{
                        self.deadlineLabel2.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAYS", comment: "")
                    }
                    break;
                case 3:
                    if deadline == 1 {
                        self.deadlineLabel3.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAY", comment: "")
                    }
                    else{
                        self.deadlineLabel3.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAYS", comment: "")
                    }
                    break;
                case 4:
                    if deadline == 1 {
                        self.deadlineLabel4.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAY", comment: "")
                    }
                    else{
                        self.deadlineLabel4.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAYS", comment: "")
                    }
                    break;
                case 5:
                    if deadline == 1 {
                        self.deadlineLabel5.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAY", comment: "")
                    }
                    else{
                        self.deadlineLabel5.text = step.isFinish ? labelCompleted : "\(deadline) " + NSLocalizedString("DAYS", comment: "")
                    }
                    break;
                default:
                    break;
                }
            }
        }
        
    }
    
    func drawLineFromPoint(start: CGPoint, toPoint end: CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.5
        
        view.layer.insertSublayer(shapeLayer, below: self.button1.layer)
    }
    
    @IBAction func startChallenge(_ sender: Any) {
        //challenge = Challenge.findByName(name: self.titleLabel.text ?? "")
        let _ = challenge.start()
        let deadline = steps[0].daysToDeadline()
        if deadline == 1 {
            self.deadlineLabel1.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
        }
        else{
            self.deadlineLabel1.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
        }
        //self.startButton.alpha = 0
        updateUI()
    }
    @IBAction func completeStep1(_ sender: Any) {
        self.button1.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel1.text = labelCompleted
        let deadline = steps[1].daysToDeadline()
        if deadline == 1 {
            self.deadlineLabel2.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
        }
        else{
            self.deadlineLabel2.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
        }
        updateUI()
    }
    @IBAction func completeStep2(_ sender: Any) {
        self.button2.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel2.text = labelCompleted
        let deadline = steps[2].daysToDeadline()
        if deadline == 1 {
            self.deadlineLabel3.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
        }
        else{
            self.deadlineLabel3.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
        }
        updateUI()
    }
    @IBAction func completeStep3(_ sender: Any) {
        self.button3.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel3.text = labelCompleted
        let deadline = steps[3].daysToDeadline()
        if deadline == 1 {
            self.deadlineLabel4.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
        }
        else{
            self.deadlineLabel4.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
        }
        updateUI()
    }
    @IBAction func completeStep4(_ sender: Any) {
        self.button4.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel4.text = labelCompleted
        let deadline = steps[4].daysToDeadline()
        if deadline == 1 {
            self.deadlineLabel5.text = "\(deadline) " + NSLocalizedString("DAY", comment: "")
        }
        else{
            self.deadlineLabel5.text = "\(deadline) " + NSLocalizedString("DAYS", comment: "")
        }
        updateUI()
    }
    @IBAction func completeStep5(_ sender: Any) {
        self.button5.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel5.text = labelCompleted
        updateUI()
        DispatchQueue.main.async {
            let endNotification = Notification.Name("endNotification")
            NotificationCenter.default.post(name: endNotification, object: nil)
        }
    }
}
