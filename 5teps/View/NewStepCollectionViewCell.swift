//
//  NewStepCollectionViewCell.swift
//  5teps
//
//  Created by Fabio Palladino on 13/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class NewStepCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: NewStepCollectionViewCell.self)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    var numDays = ["1","2","3","4","5","6","7"]
    
    var step: StepBase? {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        createPickerView()
        dismissPickerView()
        
        nameTextField.tag = 1
        nameTextField.delegate = self
        
    }
    func updateUI() {
        daysLabel.text = "days"
        if let step = self.step {
            nameTextField.text = step.name
            dayTextField.text = "\(step.days)"
            
            if step.state == StepChallengeState.Create {
                nameTextField.isUserInteractionEnabled = true
                dayTextField.isUserInteractionEnabled = true
            } else {
                nameTextField.isUserInteractionEnabled = false
                dayTextField.isUserInteractionEnabled = false
            }
        }
        
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = NewStepLayoutConstants.Cell.featuredHeight
        let standardHeight = NewStepLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        //let minAlpha: CGFloat = 0.3
        //let maxAlpha: CGFloat = 0.75
        
        //imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        //daysLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        //nameTextField.transform = CGAffineTransform(scaleX: scale, y: scale)
        //dayTextField.transform = CGAffineTransform(scaleX: scale, y: scale)
        containerView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        //timeAndRoomLabel.alpha = delta
        //speakerLabel.alpha = delta
    }
}

extension NewStepCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numDays.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numDays[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayTextField.text = numDays[row]
    }
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        dayTextField.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.actionEnd))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        dayTextField.inputAccessoryView = toolBar
    }
    @objc func actionEnd() {
        if let tmp = self.dayTextField.text {
            step?.days = Int(tmp) ?? 0
        }
        self.dayTextField.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            step?.name = textField.text ?? ""
        }
    }
}
