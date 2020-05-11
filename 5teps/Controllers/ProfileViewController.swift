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
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var goalSegment: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var user: User?
    var referenceForViewTop : Subview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        self.profileImageView.image =  UIImage(named:"mentor")
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        user = User.userData
        
        nameTextView.text = user?.name
        
        updateView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        user?.name = nameTextView.text
        user?.save()
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

    
}
