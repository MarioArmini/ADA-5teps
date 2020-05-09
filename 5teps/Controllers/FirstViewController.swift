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
    @IBOutlet weak var topicLabelTest: UILabel!
    var referenceForViewTop : Subview?
    
    
    
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
        referenceForViewTop?.greetings(imageName: "mentor")
        //------------------------------------------------------------------
        
        // MARK: load default data from json
        let topics = Topic.list()
        if topics.count == 0 {
            let json = ImportData.importJson()
            ImportData.saveTopic(topics: json)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        topicLabelTest.text = ""
        let topics = Topic.list()
        for topic in topics {
            print(topic)
            topicLabelTest.text = topicLabelTest.text! + "\n \(String(describing: topic.name)) - \(String(describing: topic.icon))"
        }
    }
}

// MARK: Mentor SubviewDelegate
extension FirstViewController : SubviewDelegate {
    func didTapOnMe(name: String, showMessage: String) {
        print("name: \(name), message: \(showMessage)")
    }
    
}
