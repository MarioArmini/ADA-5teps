//
//  Onboarding.swift
//  5teps
//
//  Created by Giusy Di Paola on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit


class Onboarding: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var barBottom: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    var mentor = Subview()
    var slides:[Slide] = []
    var userDef = true
    let app = AppDelegate.app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        scrollView.isExclusiveTouch = true
        self.scrollView.canCancelContentTouches = true
        self.scrollView.delaysContentTouches = true
        view.bringSubviewToFront(pageControl)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "tutorialAccepted") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "SecondVC")
            AppDelegate.app.window?.rootViewController = rootViewController
        }
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide1.imageView.image = UIImage(named: "mentor")
        slide1.title.text = "Start"
        slide1.desc.text  = "If not now, when? Every deck is a goal to achieve. Find the most engaging for you and overcome every challenge! Nothing suitable? Create one yourself!"
        slide1.imageForTest.image = UIImage(named: "onboarding1")
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide2.imageView.image = UIImage(named: "mentor")
        slide2.title.text = "Pick"
        slide2.desc.text = "Feeling Brave? Create your own challenge: set your steps, your deadlines and you're ready to go! Don't forget to check your steps as done to keep your progress updated!"
        slide2.imageForTest.image = UIImage(named: "onboarding2")
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide3.imageView.image = UIImage(named: "mentor")
        slide3.title.text = "Smash"
        slide3.desc.text = "Win every challenge in order to achieve your goals and reach everyday an higher level! Our virtual assistant will support you during your personal growth."
       slide3.imageForTest.image = UIImage(named: "onboarding3")
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if pageIndex == 2{
            changeTitle()
        }else{
            skipButton.setTitle("Skip", for: .normal)
            
        } 
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    func changeTitle() {
        skipButton.setTitle("Start", for: .normal)
        
    }
    
    @IBAction func start(_ sender: Any) {
    
         UserDefaults.standard.set(true, forKey: "tutorialAccepted")
        
    }
}
    

