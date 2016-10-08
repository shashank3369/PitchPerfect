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
    @IBOutlet weak var scrubberSlider: UISlider!
    
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
        scrubberSlider.value = 0.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        if (audioPlayer.isPlaying) {
            audioPlayer.currentTime = TimeInterval(sender.value)
        }
        else if (audioPlayerNode.isPlaying) {
            let nodetime: AVAudioTime  = audioPlayerNode.lastRenderTime!
            let playerTime: AVAudioTime = audioPlayerNode.playerTime(forNodeTime: nodetime)!
            let sampleRate = playerTime.sampleRate
            
            let newsampletime = AVAudioFramePosition(sampleRate * Double(sender.value))

            let songDuration = Double(audioFile.length)/(audioPlayerNode.lastRenderTime?.sampleRate)!
            let length = Float(songDuration) - sender.value
            let framestoplay = AVAudioFrameCount(Float(playerTime.sampleRate) * length)
            
            audioPlayerNode.stop()
            if framestoplay > 1000 {
                audioPlayerNode.scheduleSegment(audioFile, startingFrame: newsampletime, frameCount: framestoplay, at: nil,completionHandler: nil)
            }
            setupScrubber(max: Float(Double(audioFile.length)/(audioPlayerNode.lastRenderTime?.sampleRate)!))
            print("\(scrubberSlider.value) \(scrubberSlider.minimumValue) \(scrubberSlider.maximumValue)")
            audioPlayerNode.play()
        }
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

}
