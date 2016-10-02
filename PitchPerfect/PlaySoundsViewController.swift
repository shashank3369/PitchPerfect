//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Kothapalli on 8/29/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {


    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!

    
    var recordedAudio: RecordedObject!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var audioPlayer: AVAudioPlayer!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playWithSpeed(0.5)
            
            case .fast:
                playWithSpeed(2.0)
            
            case .chipmunk:
                playWithPitch(1000)
            
            case .vader:
                playWithPitch(-1000)
            
            case .echo:
                playWithEffect("echo")
            
            case .reverb:
                playWithEffect("reverb")
                
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
    }

}
