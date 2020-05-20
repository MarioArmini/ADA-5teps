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
    var challenge: Challenge!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func verifySteps(){
        if self.steps[0].isFinish{
            self.button1.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button1.center, toPoint: self.button2.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel1.text = "Completed"
            let deadline = steps[0].daysToDeadline()
            self.deadlineLabel2.text = "\(deadline) day/s"
        }
        else if !self.steps[0].isFinish{
            self.button1.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel1.text = ""
            self.deadlineLabel2.text = ""
        }
        if self.steps[1].isFinish{
            self.button2.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button2.center, toPoint: self.button3.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel2.text = "Completed"
            let deadline = steps[1].daysToDeadline()
            self.deadlineLabel3.text = "\(deadline) day/s"
        }
        else if !self.steps[1].isFinish{
            self.button2.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel2.text = ""
            self.deadlineLabel3.text = ""
        }
        if self.steps[2].isFinish{
            self.button3.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button3.center, toPoint: self.button4.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel3.text = "Completed"
            let deadline = steps[2].daysToDeadline()
            self.deadlineLabel4.text = "\(deadline) day/s"
        }
        else if !self.steps[2].isFinish{
            self.button3.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel3.text = ""
            self.deadlineLabel4.text = ""
        }
        if self.steps[3].isFinish{
            self.button4.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            //drawLineFromPoint(start: self.button4.center, toPoint: self.button5.center, ofColor: UIColor.black, inView: self)
            self.deadlineLabel4.text = "Completed"
            let deadline = steps[3].daysToDeadline()
            self.deadlineLabel5.text = "\(deadline) day/s"
        }
        else if !self.steps[3].isFinish{
            self.button4.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel4.text = ""
            self.deadlineLabel5.text = ""
        }
        if self.steps[4].isFinish{
            self.button5.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.deadlineLabel5.text = "Completed"
        }
        else if !self.steps[4].isFinish{
            self.button5.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            self.deadlineLabel5.text = ""
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
        self.deadlineLabel1.text = "\(deadline) day/s"
        self.startButton.alpha = 0
    }
    @IBAction func completeStep1(_ sender: Any) {
        self.button1.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel1.text = "Completed"
        let deadline = steps[1].daysToDeadline()
        self.deadlineLabel2.text = "\(deadline) day/s"
    }
    @IBAction func completeStep2(_ sender: Any) {
        self.button2.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel2.text = "Completed"
        let deadline = steps[2].daysToDeadline()
        self.deadlineLabel3.text = "\(deadline) day/s"
    }
    @IBAction func completeStep3(_ sender: Any) {
        self.button3.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel3.text = "Completed"
        let deadline = steps[3].daysToDeadline()
        self.deadlineLabel4.text = "\(deadline) day/s"
    }
    @IBAction func completeStep4(_ sender: Any) {
        self.button4.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel4.text = "Completed"
        let deadline = steps[4].daysToDeadline()
        self.deadlineLabel5.text = "\(deadline) day/s"
    }
    @IBAction func completeStep5(_ sender: Any) {
        self.button5.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        if challenge.isCreate {
            let _ = challenge.start()
            return
        }
        let _ = challenge.nextStep()
        self.deadlineLabel5.text = "Completed"
    }
}
