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

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudio: RecordedObject!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    var audioPlayer: AVAudioPlayer!
    var timer: NSTimer!
    
    enum ButtonType: Int { case Slow = 0, Fast, Vader, Chipmunk, Echo, Reverb }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(PlaySoundsViewController.shareSound))
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:self, action:#selector(PlaySoundsViewController.stopSound))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func shareSound() {
        let urlToShare = recordedAudio.filePathURL
        let activityVC = UIActivityViewController(activityItems: [urlToShare], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func playButton(sender: UIButton) {
        if (self.audioPlayer.playing) {
            self.audioPlayer.stop()
            self.timer.invalidate()
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(PlaySoundsViewController.updateSliderLocation), userInfo: nil, repeats: true)
        configureUI("Playing")
        switch (ButtonType(rawValue: sender.tag)!) {
            case .Slow:
                playWithSpeed(0.5)
                break
            case .Fast:
                playWithSpeed(2.0)
                break
            case .Chipmunk:
                playWithPitch(1000)
                break
            case .Vader:
                playWithPitch(1000)
                break
            case .Echo:
                playWithEffect("echo")
                break
            case .Reverb:
                playWithEffect("reverb")
                break
        }
    }
    
    @IBAction func stopPlayButton(sender: UIButton) {
        configureUI("NotPlaying")
        if(self.audioPlayerNode.playing) {
            self.audioPlayerNode.stop()
        }
        if(self.audioPlayer.playing) {
            self.audioPlayer.stop()
        }
    }

    override func viewWillAppear(animated: Bool) {
        configureUI("NotPlaying")
    }

    /* Controlling Playback */
    func updateSliderLocation() {
        if (self.audioPlayer.playing) {
            slider.value = Float(self.audioPlayer.currentTime)
        }
        else if (self.audioPlayerNode.playing){
            slider.value = Float(currentTime())
        }
    }
    
    @IBAction func scrollThroughAudio(sender: AnyObject) {
        if (self.audioPlayer.playing) {
            self.audioPlayer.stop()
            self.audioPlayer.currentTime = NSTimeInterval(slider.value)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
        else if (self.audioPlayerNode.playing) {
            self.audioPlayerNode.stop()
            var nodetime: AVAudioTime  = self.audioPlayerNode.lastRenderTime!
            var playerTime: AVAudioTime = self.audioPlayerNode.playerTimeForNodeTime(nodetime)!
            var sampleRate = playerTime.sampleRate
            var newsampletime = AVAudioFramePosition(sampleRate * Double(slider.value))
            var length = Float(self.audioPlayer.duration) - slider.value
            var framestoplay = AVAudioFrameCount(Float(playerTime.sampleRate) * length)
            if framestoplay > 100 {
                self.audioPlayerNode.scheduleSegment(audioFile, startingFrame: newsampletime, frameCount: framestoplay, atTime: nil,completionHandler: nil)
            }
            self.audioPlayerNode.play()
        }
    }
    
    
    /* Controlling Speed and Pitch and Effects*/
    func playWithSpeed(rate: Float) {
        self.slider.maximumValue = Float(self.audioPlayer.duration)
        configureUI("Playing")
        self.audioPlayer.rate = rate
        self.audioPlayer.play()
        stopTimer(self.audioPlayer.duration)
    }
    
    
    func playWithPitch(pitch: Float) {
        self.slider.maximumValue = Float(self.audioFile.length)
        configureUI("Playing")
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        let pitchChosen = AVAudioUnitTimePitch()
        pitchChosen.pitch = pitch
        audioEngine.attachNode(pitchChosen)
        
        audioEngine.connect(audioPlayerNode, to: pitchChosen, format: nil)
        audioEngine.connect(pitchChosen, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }
        catch {
            
        }
        stopTimer(Double(audioFile.length))
        audioPlayerNode.play()
        
        
    }
    
    func playWithEffect(effect:String) {
        
    }
    
    /* UI Functions */
    func configureUI(playState: String) {
        switch(playState) {
            case "Playing":
                setPlayButtonsEnabled(false)
                stopButton.enabled = true
                break
            case "NotPlaying":
                setPlayButtonsEnabled(true)
                stopButton.enabled = false
                break
            default:
                break
        }
    }
    
    func stopTimer(seconds:Double) {
        self.stopTimer = NSTimer(timeInterval: seconds, target: self, selector: #selector(PlaySoundsViewController.stopAudio), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.stopTimer!, forMode: NSDefaultRunLoopMode)
    }
    func setPlayButtonsEnabled(enabled: Bool) {
        snailButton.enabled = enabled
        chipmunkButton.enabled = enabled
        rabbitButton.enabled = enabled
        vaderButton.enabled = enabled
        echoButton.enabled = enabled
        reverbButton.enabled = enabled
    }
    
    
    /* Setup */
    func setupAudio() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        // initialize (recording) audio file
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: recordedAudio.filePathURL)
            audioFile = try AVAudioFile(forReading: recordedAudio.filePathURL)
        } catch {
            
        }
        self.audioPlayer.enableRate = true
        print("Audio has been setup")
    }
    
    func stopAudio() {
        self.stopTimer.invalidate()
        configureUI("NotPlaying")
        if(self.audioPlayerNode.playing) {
            self.audioPlayerNode.stop()
        }
        if(self.audioPlayer.playing) {
            self.audioPlayer.stop()
        }

    }
    
    func stopSound() {
        self.timer.invalidate()
        configureUI("NotPlaying")
        if(self.audioPlayerNode.playing) {
            self.audioPlayerNode.stop()
        }
        if(self.audioPlayer.playing) {
            self.audioPlayer.stop()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func currentTime() -> NSTimeInterval {
        let nodeTime = self.audioPlayerNode.lastRenderTime
        let playerTime = self.audioPlayerNode.playerTimeForNodeTime(nodeTime!)
        
        return Double((playerTime?.sampleTime)!)/(playerTime?.sampleRate)!
    }

}
