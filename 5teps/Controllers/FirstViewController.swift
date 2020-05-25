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
    
    let flowLayout = ZoomAndSnapFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        // MARK: Mentor top view settings ------------------------------------
        if let referenceForViewOnTheTop = Bundle.main.loadNibNamed("Subview", owner: self, options: nil)?.first as? Subview  {
            viewMentorTop.addSubview(referenceForViewOnTheTop)
            referenceForViewOnTheTop.frame.size.height = viewMentorTop.frame.size.height
            referenceForViewOnTheTop.frame.size.width = viewMentorTop.frame.size.width
            referenceForViewOnTheTop.subViewDelegate = self
            referenceForViewTop = referenceForViewOnTheTop
        }
        
        // MARK: update Mentor topview -------------------------------------------------------------
       
        //referenceForViewTop?.settingsMentor(imageName: "mentor", text: "Hello!")
        referenceForViewTop?.greetingsMentor()
        //------------------------------------------------------------------
        
        TopicCollectionView.register(UINib.init(nibName: "TopicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "topicCollectionViewCell")
        TopicCollectionView.collectionViewLayout = flowLayout
        TopicCollectionView.contentInsetAdjustmentBehavior = .always
        TopicCollectionView.dataSource = self
        TopicCollectionView.delegate = self
        
        // MARK: load default data from json
        topics = Topic.list()
        if topics.count == 0 {
            let json = ImportData.importJson()
            ImportData.saveTopic(topics: json)
        }
        
        let deleteNotification = Notification.Name("deleteNotificationTopic")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTopic), name: deleteNotification, object: nil)
        
        let nameNotification = Notification.Name("editNotificationTopic")
        NotificationCenter.default.addObserver(self, selector: #selector(editTopic), name: nameNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    func reloadData() {
        topics = Topic.list()
        TopicCollectionView.reloadData()
    }
    @IBAction func onClickNewTopic(_ sender: UIBarButtonItem) {
        let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newTopicView") as! NewTopicViewController
        viewTmp.parentVC = self
        //self.navigationController?.pushViewController(viewTmp, animated: true)
        self.present(viewTmp, animated: true) {
            
        }
    }
    @objc func deleteTopic(_ notification: Notification){
        if let id = notification.object as? UUID {
            if let c = Topic.findById(id: "\(id)") {
                let alert = UIAlertController(title: "Attention", message: "Do you want to delete this topic?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    c.delete()
                    self.reloadData()
                    }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    @objc func editTopic(_ notification: Notification){
        if let topicReceived = notification.object as? Topic {
            let viewTmp = UIStoryboard(name: "NewTopic", bundle: nil).instantiateViewController(withIdentifier: "newTopicView") as! NewTopicViewController
            viewTmp.parentVC = self
            viewTmp.topic = topicReceived
            self.present(viewTmp, animated: true) {
                
            }
            //self.navigationController?.pushViewController(viewTmp, animated: true)
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            let vc = UIStoryboard(name: "NewTopic", bundle: Bundle.main).instantiateViewController(identifier: "randomChallengeView") as! RandomChallengeViewController
            vc.parentVC = self
            self.present(vc, animated: true, completion: {
                print("finish lanch random view")
            })
        }
    }
}


extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCollectionViewCell", for: indexPath) as! TopicCollectionViewCell
        cell.topic = self.topics[indexPath.section]
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //cell.contentView.backgroundColor = UIColor.green
        
        return cell
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     //let w = collectionView.layer.bounds.width * 0.60
     //let h = collectionView.layer.bounds.height * 0.60
     return CGSize(width: 150, height: 200)
     }*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.section]
        //print(topic)
        defaults.set(topic.name, forKey: "topicName")
        let viewTmp = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "challengeView") as! ChallengesViewController
        self.navigationController?.pushViewController(viewTmp, animated: true)
    }
    
}



// MARK: Mentor SubviewDelegate
extension FirstViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
}
extension FirstViewController : OnCloseChildView {
    func onOpenChallengeView(topic: Topic) {
        defaults.set(topic.name, forKey: "topicName")
        
        let viewTmp = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "challengeView") as! ChallengesViewController
        //viewTmp.parentVC = self
        self.navigationController?.pushViewController(viewTmp, animated: true)
    }
    
}
