//
//  FirstViewController.swift
//  5teps
//
//  Created by Mario Armini on 07/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var viewMentorTop: UIView!
    @IBOutlet weak var TopicCollectionView: UICollectionView!
    var referenceForViewTop : Subview?
    var topics: [Topic]!
    let defaults = UserDefaults.standard
    
    
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
        
        // MARK: load default data from json
        topics = Topic.list()
        if topics.count == 0 {
            let json = ImportData.importJson()
            ImportData.saveTopic(topics: json)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        topics = Topic.list()
        TopicCollectionView.reloadData()
    }
    @IBAction func onClickNewTopic(_ sender: UIBarButtonItem) {
        let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newTopicView") as! NewTopicViewController
        self.navigationController?.pushViewController(viewTmp, animated: true)
    }
    
}

extension FirstViewController: UICollectionViewDelegate{
    
}

extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicCollectionViewCell
        cell.TopicLabel.text = self.topics[indexPath.section].name
        //cell.TopicIconView.image = topics[indexPath.section].icon?.emojiToImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.layer.bounds.width
        return CGSize(width: w, height: 528)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defaults.set(topics[indexPath.section].name, forKey: "topicName")
    }
    
}



// MARK: Mentor SubviewDelegate
extension FirstViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
