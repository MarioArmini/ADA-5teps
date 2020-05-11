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
    @IBOutlet weak var stepsPickerView: UIPickerView!
    
    var referenceForViewTop : Subview?
    public var topic: Topic?
    var steps: [StepChallenge]!
    
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
        referenceForViewTop?.backgroundColor = UIColor.gray
        //referenceForViewTop?.settingsMentor(imageName: "mentor", text: "Hello!")
        referenceForViewTop?.greetingsMentor()
        //------------------------------------------------------------------
        
        // Do any additional setup after loading the view.
        
        steps = [StepChallenge]()
        for i in 1...5 {
            let step = StepChallenge(context: SharedInfo.context)
            step.id = UUID()
            step.name = "Step #\(i)"
            step.timestamp = Date()
            step.state = StepChallengeState.Create.rawValue
            step.days = 1
            step.step = Int64(i)
            
            steps.append(step)
        }
        
        stepsPickerView.delegate = self
        stepsPickerView.dataSource = self
        
    }
    @IBAction func onClickDone(_ sender: Any) {
        if nameTextField.text?.count == 0{
            Utils.showMessage(vc: self, title: "Field Mandatory", msg: "Insert name of topic")
            return
        }
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
            challenge.addToSteps(s)
        }
        
        challenge.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
// MARK: Mentor SubviewDelegate
extension NewChallengeViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
extension NewChallengeViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return steps?.count ?? 0
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return ""
    }*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let w = pickerView.layer.bounds.width - 40
        return w
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let w = pickerView.layer.bounds.width - 40
        
        let parentView = UIView()
        let step = steps[row]
        let textField = UITextField(frame: CGRect(x: 10, y: 0, width: w, height: 50))
        let stepper = UIStepper(frame: CGRect(x: 10, y: 50, width: 50, height:50))
        let labelDays = UILabel(frame: CGRect(x: stepper.layer.bounds.width + 20, y: 40, width: w - stepper.layer.bounds.width + 20, height: 50))
        
        textField.text = step.name
        labelDays.text = "\(step.days) day"
        stepper.value = Double(step.days)
        stepper.minimumValue = 1
        stepper.maximumValue = 7
        
        //textField.delegate = self
        textField.isUserInteractionEnabled = true
        
        
        parentView.addSubview(textField)
        parentView.addSubview(stepper)
        parentView.addSubview(labelDays)
        
        return parentView
    }
    
}
