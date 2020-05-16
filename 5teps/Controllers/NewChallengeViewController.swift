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
    
    var referenceForViewTop : Subview?
    public var topic: Topic?
    public var challenge: Challenge?
    var steps: [StepBase]!
    
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
                step.name = "Step #\(i)"
                step.days = 1
                steps.append(step)
            }
        }
        
        stepsCollectionView.delegate = self
        stepsCollectionView.dataSource = self
        stepsCollectionView?.backgroundColor = .clear
        stepsCollectionView?.decelerationRate = .fast
    }
    @IBAction func onClickDone(_ sender: Any) {
        if nameTextField.text?.count == 0{
            Utils.showMessage(vc: self, title: "Field Mandatory", msg: "Insert name of topic")
            return
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
                step.name = s.name
                step.timestamp = Date()
                step.state = StepChallengeState.Create.rawValue
                step.days = Int16(s.days)
                step.step = Int64(s.step)
                challenge.addToSteps(step)
            }
            
            challenge.save()
        }
        
        self.navigationController?.popViewController(animated: true)
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
