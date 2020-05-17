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
    
    var user: User?
    var referenceForViewTop : Subview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    func updateUI() {
        user = User.userData
        nameLabel.text = user?.name
        
        self.profileImageView.image = user?.getProfiloImage()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        
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
