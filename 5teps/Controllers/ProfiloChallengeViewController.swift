//
//  ProfiloChallengeViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 11/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ProfiloChallengeViewController: UIViewController {

    @IBOutlet weak var challangeCollectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var sections: [Int: [Challenge]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        challangeCollectionView.register(UINib.init(nibName: "CardProfiloViewCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        
        challangeCollectionView.delegate = self
        challangeCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        sections = [Int: [Challenge]]()
        sections[0] = Challenge.listByState(state: ChallengeState.Finished)
        
        if sections[0]?.count == 0 {
            //sections[0] = Challenge.list()
        }
        
        challangeCollectionView.reloadData()
    }
}
extension ProfiloChallengeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardProfiloViewCell
        if let challenge = sections[indexPath.section]?[indexPath.row] {
            cell.challenge = challenge
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        var left: CGFloat = sectionInsets.left
        left = (left == 0) ? 5 : left
        //2
        let paddingSpace = left * (itemsPerRow + 1)
        let availableWidth = collectionView.layer.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem: CGFloat = 219
        
        return CGSize(width: widthPerItem, height: heightPerItem)
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
        var bottom: CGFloat = sectionInsets.bottom
        bottom = (bottom == 0) ? 10 : bottom
        return bottom
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
}
