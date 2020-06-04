//
//  Onboarding.swift
//  5teps
//
//  Created by Giusy Di Paola on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit


class Onboarding: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var hiddenButton: UIButton!
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
        slide1.title.text = NSLocalizedString("SLIDE_1_TITLE", comment: "")
        slide1.desc.text  = "If not now, when? Every deck is a goal to achieve. Find the most engaging for you and overcome every challenge! Nothing suitable? Create one yourself!"
        slide1.desc.text = NSLocalizedString("SLIDE_1_DESC", comment: "")
        slide1.imageForTest.image = UIImage(named: "onboarding1")
        //barBottom.image = UIImage(named: "barBottom")
        hiddenButton.isHidden = true
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide2.imageView.image = UIImage(named: "mentor")
        hiddenButton.isHidden = true
        slide2.title.text = "Pick"
        slide2.title.text = NSLocalizedString("SLIDE_2_TITLE", comment: "")
        slide2.desc.text = "Feeling Brave? \nCreate your own challenge: set your steps, your deadlines and you're ready to go! Don't forget to check your steps as done to keep your progress updated!"
        slide2.desc.text = NSLocalizedString("SLIDE_2_DESC", comment: "")
        slide2.imageForTest.image = UIImage(named: "onboarding2")
        barBottom.image = UIImage(named: "barBottom")
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        hiddenButton.isHidden = true
        //slide3.imageView.image = UIImage(named: "mentor")
        slide3.title.text = "Smash"
        slide3.title.text = NSLocalizedString("SLIDE_3_TITLE", comment: "")
        slide3.desc.text = "Win every challenge in order to achieve your goals and reach everyday an higher level! Our virtual assistant will support you during your personal growth."
        slide3.desc.text = NSLocalizedString("SLIDE_3_DESC", comment: "")
        slide3.imageForTest.image = UIImage(named: "onboarding3")
        
        
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
               //slide3.imageView.image = UIImage(named: "mentor")
               slide4.title.text = "Meet Oscar"
               slide4.title.text = NSLocalizedString("SLIDE_4_TITLE", comment: "")
               slide4.desc.text = "You won't be alone! Oscar, your mentor, will guide you through your personal growth by giving you motivation, information and everything you need to reach your goals."
               slide4.desc.text = NSLocalizedString("SLIDE_4_DESC", comment: "")
               slide4.imageForTest.image = UIImage(named: "mentoronboarding")
               hiddenButton.isHidden = false
        //pageControl.isHidden = true
        
        
        
        return [slide1, slide2, slide3, slide4]
        
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
        
        if pageIndex == 3{
            //changeTitle()
            skipButton.isHidden = true
           /* UIView.transition(with: self.barBottom, duration: 1.0, options: .transitionFlipFromBottom, animations: {
                self.barBottom.image =  UIImage(named: "getstarted")
            }, completion: nil)*/
            hiddenButton.setTitle("GET STARTED", for: .normal)
            hiddenButton.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
            barBottom.image = UIImage(named: "getstarted")
            pageControl.isHidden = true
            hiddenButton.isHidden = false
        }else{
            /*UIView.transition(with: self.barBottom, duration: 1.0, options: .transitionFlipFromBottom, animations: {
                self.barBottom.image =  UIImage(named: "barBottom")
            }, completion: nil)*/
            skipButton.setTitle("SKIP", for: .normal)
            barBottom.image = UIImage(named: "barBottom")
            pageControl.isHidden = false
            skipButton.isHidden = false
            hiddenButton.isHidden = true
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
    
    @IBAction func whenGetStartedIsPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "tutorialAccepted")
    }
    
}


