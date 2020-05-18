//
//  NewTopicViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class NewTopic2ViewController: UIViewController {
    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var collectionViewIcons: UICollectionView!
    @IBOutlet weak var collectionViewColors: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var referenceForViewTop : Subview?
    
    var icons = Utils.getArrayIcon()
    var colors = Utils.getArrayColor()
    var currentBG: UIColor = UIColor.white
    public var topic: Topic?
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

        
        collectionViewIcons.delegate = self
        collectionViewIcons.dataSource = self
        collectionViewColors.delegate = self
        collectionViewColors.dataSource = self
        
        if topic != nil {
            nameTextField.text = topic?.name
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionViewIcons.reloadData()
        collectionViewColors.reloadData()
    }
    
    @IBAction func onClickDone(_ sender: UIBarButtonItem) {
        if nameTextField.text?.count == 0{
            Utils.showMessage(vc: self, title: "Field Mandatory", msg: "Insert name of topic")
            return
        }
        let iconsSel = collectionViewIcons.indexPathsForSelectedItems
        if iconsSel == nil || iconsSel?.count == 0 {
            Utils.showMessage(vc: self, title: "Field Mandatory", msg: "Select the icon")
            return
        }
        let colorSel = collectionViewColors.indexPathsForSelectedItems
        if colorSel == nil || colorSel?.count == 0 {
            Utils.showMessage(vc: self, title: "Field Mandatory", msg: "Select the color's card")
            return
        }
        
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
        topic?.color = colors[colorSel![0].section].color2
        topic?.icon = icons[iconsSel![0].section]
        topic?.name = nameTextField.text
        topic?.save()
        
        self.navigationController?.popViewController(animated: true)
        
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

extension NewTopic2ViewController: UICollectionViewDelegate{
    
}

extension NewTopic2ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 1 {
            return icons.count
        }
        else if collectionView.tag == 2 {
            return colors.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewTopicCollectionViewCell
            cell.iconLabel.text = self.icons[indexPath.section]
            cell.contentView.backgroundColor = currentBG
            return cell
        }
        else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellColor", for: indexPath) as! ColorCollectionViewCell
            cell.viewColor.backgroundColor = Utils.hexStringToUIColor(hex: colors[indexPath.section].color2)
            return cell
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionViewIcons.bounds.width
        if collectionView.tag == 1 {
            return CGSize(width: w, height: 300)
        }
        else if collectionView.tag == 2 {
            return CGSize(width: 60, height: 60)
        }
        return CGSize(width: 60, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            currentBG = Utils.hexStringToUIColor(hex: colors[indexPath.section].color2)
            let selItems = collectionViewIcons.indexPathsForVisibleItems
            
            collectionViewIcons.reloadData()
            if selItems.count > 0 {
                collectionViewIcons.selectItem(at: selItems[selItems.count - 1], animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
}
// MARK: Mentor SubviewDelegate
extension NewTopic2ViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
