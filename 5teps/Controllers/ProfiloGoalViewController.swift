//
//  ProfiloGoalViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 11/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ProfiloGoalViewController: UIViewController {
    @IBOutlet weak var goalCollectionView: UICollectionView!
    
    var goals: [Goal]!
    var sections: [Int:[Goal]]!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    override func viewDidLoad() {
        super.viewDidLoad()

        goalCollectionView.register(UINib.init(nibName: "MedalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "medalCell")
        
        goalCollectionView.delegate = self
        goalCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sections = [Int:[Goal]]()
        goals = Goal.list()
        if goals.count == 0 {
            //goals = Goal.generaFakeGoals()
        }
        let section = 0
        for g in goals {
            if(!sections.keys.contains(section)) {
                sections[section] = [Goal]()
            }
            sections[section]?.append(g)
        }
        
        goalCollectionView.reloadData()
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

extension ProfiloGoalViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "medalCell", for: indexPath) as! MedalCollectionViewCell
        //cell.contentView.backgroundColor = UIColor.red
        if let goal = sections[indexPath.section]?[indexPath.row] {
            cell.goal = goal
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.layer.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
