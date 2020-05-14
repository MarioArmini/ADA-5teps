//
//  NewTopicViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class NewTopicViewController: UIViewController {
    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconsPickerView: UIPickerView!
    @IBOutlet weak var colorsPickerView: UIPickerView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    var referenceForViewTop : Subview?
    
    var icons = Utils.getArrayIcon()
    var colors = Utils.getArrayColor()
    var currentBG: UIColor = UIColor.white
    public var topic: Topic?
    public var parentVC: OnCloseChildView?
    
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
        
        colorsPickerView.delegate = self
        iconsPickerView.delegate = self
        colorsPickerView.dataSource = self
        iconsPickerView.dataSource = self
        if topic != nil {
            nameTextField.text = topic?.name
        }
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = true
        cardView.backgroundColor = UIColor.red
        cardView.layer.borderWidth = 2.0
        cardView.layer.borderColor = UIColor.black.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        if topic != nil {
            if let index = icons.firstIndex(of: topic!.icon!) {
                iconsPickerView.selectRow(index, inComponent: 0, animated: true)
            }
            if let index = colors.firstIndex(of: topic!.color!) {
                colorsPickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
        
    }
    
    @IBAction func onClickDone(_ sender: UIBarButtonItem) {
        if nameTextField.text?.count == 0{
            Utils.showMessage(vc: self, title: "Field Mandatory", msg: "Insert name of topic")
            return
        }
        
        let iconsSel = icons[iconsPickerView.selectedRow(inComponent: 0)]
        let colorSel = colors[colorsPickerView.selectedRow(inComponent: 0)]
        
        
        if topic == nil {
            topic = Topic.findByName(name: nameTextField.text!)
            if topic == nil {
                topic = Topic(context: SharedInfo.context)
                topic?.active = true
                topic?.id = UUID()
                topic?.timestamp = Date()
                topic?.user = User.userData
            }
        }
        topic?.color = colorSel
        topic?.icon = iconsSel
        topic?.name = nameTextField.text
        topic?.save()
        
        self.navigationController?.popViewController(animated: true)
        parentVC?.onOpenChallengeView(topic: topic!)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: Mentor SubviewDelegate
extension NewTopicViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
extension NewTopicViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return icons.count
        }
        return colors.count
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     {
     return ""
     }*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let w = pickerView.layer.bounds.width
        return w
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let w = pickerView.layer.bounds.width
        return w
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let w = pickerView.layer.bounds.width
        
        let parentView = UIView()
        if pickerView.tag == 1 {
            let wlabel = w
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: wlabel, height: wlabel))
            
            image.image = icons[row].emojiToImage()
            image.contentMode = .scaleAspectFit
            
            DispatchQueue.main.async {
                self.cardImageView.image = self.icons[self.iconsPickerView.selectedRow(inComponent: 0)].emojiToImage()
            }
            
            parentView.addSubview(image)
            
        } else {
            let wlabel = w
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: wlabel, height: wlabel))
            
            image.backgroundColor = Utils.hexStringToUIColor(hex: colors[row])
            DispatchQueue.main.async {
                self.cardView.backgroundColor = Utils.hexStringToUIColor(hex: self.colors[self.colorsPickerView.selectedRow(inComponent: 0)])
            }
            
            parentView.addSubview(image)
        }
        
        return parentView
    }
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1 {
            self.cardImageView.image = self.icons[row].emojiToImage()
        } else {
            self.cardView.backgroundColor = Utils.hexStringToUIColor(hex: self.colors[row])
        }
    }
    
}
