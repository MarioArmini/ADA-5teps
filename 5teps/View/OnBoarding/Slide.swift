//
//  Slide.swift
//  5teps
//
//  Created by Giusy Di Paola on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit
import AVFoundation

class Slide: UIView, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var playMentorPresentation: UIButton!
    
    
    func playMentorAudio() {
        let soundURL = Bundle.main.url(forResource: "mentorpresentation", withExtension: "mp3")
        do {
            audioPlayer = try
                AVAudioPlayer(contentsOf: soundURL!)
            audioPlayer.play()
        }
        catch {
            print(error)
        }
    }
    
    
    
    @IBAction func whenButtonIsPressed(_ sender: UIButton) {
        playMentorAudio()
        /*   if audioPlayer.isPlaying {
         playMentorPresentation.setImage(UIImage(systemName: "pause.fill"), for: .normal)
         }else{
         audioPlayer.pause()
         playMentorPresentation.setImage(UIImage(systemName: "play.fill"), for: .normal)
         }*/
        
        
    }
    
}
