//
//  ProfileViewController.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var goalSegment: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var user: User?
    var referenceForViewTop : Subview?
    var currentLevel: CurrentLevel!
    var ring: Ring?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    func updateUI() {
        user = User.userData
        nameLabel.text = user?.name
        currentLevel = Goal.getMaxLevel()
        if(nameLabel.text?.count == 0) {
            nameLabel.text = NSLocalizedString("LABEL_NAME_EMPTY", comment: "")
        }
        
        
        self.profileImageView.image = user?.getProfiloImage()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 4.0
        self.profileImageView.clipsToBounds = true
        
        ring?.removeFromSuperview()
        ring = Ring(frame: profileImageView.bounds)
        ring?.colorCircle = UIColor(named: "blue") ?? UIColor.red
        ring?.lineWidth = 6
        ring?.endAngle = Goal.getPercentualeComplete(level: currentLevel)
        if ring!.endAngle != 0 {
            self.profileImageView.addSubview(ring!)
        }
        
        //"\(currentLevel.level)"
        levelLabel.text = String(format: NSLocalizedString("LABEL_LEVEL", comment: ""),"\(currentLevel.level)")
        
        updateView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        //user?.name = nameTextView.text
        //user?.save()
    }
    private lazy var profiloGoalViewController: ProfiloGoalViewController = {
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "profiloGoalView") as! ProfiloGoalViewController
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var profiloChallengeViewController: ProfiloChallengeViewController = {
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "profiloChallengeView") as! ProfiloChallengeViewController
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    @IBAction func onValueChangedSegment(_ sender: UISegmentedControl) {
        updateView()
    }
    func updateView() {
        if goalSegment.selectedSegmentIndex == 0 {
            remove(asChildViewController: profiloGoalViewController)
            add(asChildViewController: profiloChallengeViewController)
        } else {
            remove(asChildViewController: profiloChallengeViewController)
            add(asChildViewController: profiloGoalViewController)
        }
    }
    private func add(asChildViewController viewController: UIViewController) {

        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        var newSafeArea = UIEdgeInsets()
        newSafeArea.top = 10
        newSafeArea.left = 10
        newSafeArea.right = 10
        newSafeArea.bottom = 10
        viewController.view.frame = containerView.bounds
        viewController.additionalSafeAreaInsets = newSafeArea
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    //----------------------------------------------------------------

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    @IBAction func onClickEdit(_ sender: Any) {
        let viewTmp = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "editProfiloView") as! EditProfiloViewController
        viewTmp.parentVC = self
        self.present(viewTmp, animated: true) {
            print("load")
        }
    }
}
extension ProfileViewController: OnCloseChildView {
    func onReloadDati() -> Void {
        updateUI()
    }
}
