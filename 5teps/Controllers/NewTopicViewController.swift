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
    var gradientView: UIView?
    var gradientLayer: CAGradientLayer?
    var shadowLayer: CAShapeLayer?
    let cornerRadius: CGFloat = 20.20
    
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
        referenceForViewTop?.someStepIndications(imageName: "mentorindicates")
        //------------------------------------------------------------------
        
        colorsPickerView.delegate = self
        iconsPickerView.delegate = self
        colorsPickerView.dataSource = self
        iconsPickerView.dataSource = self
        if topic != nil {
            nameTextField.text = topic?.name
        }
        cardView.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if topic != nil {
            if let index = icons.firstIndex(of: topic!.icon!) {
                iconsPickerView.selectRow(index, inComponent: 0, animated: true)
            }
            if let index = colors.firstIndex(of: ColorCard(color1: topic!.color!, color2: topic!.color!)) {
                colorsPickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
        updateUI()
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
        topic?.color = colorSel.color2
        topic?.icon = iconsSel
        topic?.name = nameTextField.text
        topic?.save()
        
        self.navigationController?.popViewController(animated: true)
        parentVC?.onOpenChallengeView(topic: topic!)
    }
    func updateUI() {
        let iconsSel = icons[iconsPickerView.selectedRow(inComponent: 0)]
        let colorSel = colors[colorsPickerView.selectedRow(inComponent: 0)]
        
        self.cardImageView.image = UIImage(named: iconsSel)
        //self.cardView.backgroundColor = Utils.hexStringToUIColor(hex: colorSel)
        setBackgroundCard(color: colorSel)
    }
    func setBackgroundCard(color: ColorCard)  {
        let rectFrame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.cardImageView.image = UIImage(named: self.icons[row])
            //self.cardImageView.layer.cornerRadius = self.cardImageView.layer.bounds.width/2
        } else {
            setBackgroundCard(color: self.colors[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let w = pickerView.layer.bounds.width - 10
        return w
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let w = pickerView.layer.bounds.width - 10
        return w
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let w = pickerView.layer.bounds.width - 10
        
        let parentView = UIView()
        if pickerView.tag == 1 {
            let wlabel = w
            let image = UIImageView(frame: CGRect(x: 5, y: 5, width: wlabel-10, height: wlabel-10))
            
            image.image = UIImage(named: self.icons[row])
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius = image.layer.bounds.width/2
            image.clipsToBounds = true
            image.layer.borderWidth = 1.0
            image.layer.borderColor = UIColor(named: "fontColor")?.cgColor
           
            parentView.addSubview(image)
            
        } else {
            let wlabel = w
            let image = UIImageView(frame: CGRect(x: 5, y: 5, width: wlabel - 10, height: wlabel - 10))
            
            image.backgroundColor = Utils.hexStringToUIColor(hex: colors[row].color2)
            image.layer.cornerRadius = image.layer.bounds.width/2
            image.clipsToBounds = true
            parentView.addSubview(image)
        }
        
        return parentView
    }
    
}
