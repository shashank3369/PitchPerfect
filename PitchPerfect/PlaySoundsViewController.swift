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
    var stopTimer: NSTimer!
    var audioPlayer: AVAudioPlayer!
    var timer: NSTimer!
    
    enum ButtonType: Int { case Slow = 0, Fast, Vader, Chipmunk, Echo, Reverb }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playButton(sender: UIButton) {
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
                playWithPitch(-1000)
                break
            case .Echo:
                playWithEffect("echo")
                break
            case .Reverb:
                playWithEffect("reverb")
                break
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        
    }


    
    
    
    /* Controlling Speed and Pitch and Effects*/
    func playWithSpeed(rate: Float) {
        self.audioPlayer.rate = rate
        self.audioPlayer.play()
    }
    
    
    func playWithPitch(pitch: Float) {

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
        
        audioPlayerNode.play()
        
        
    }
    
    func playWithEffect(effect:String) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        if (effect == "echo") {
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.MultiEcho1)
            audioEngine.attachNode(echoNode)
            connectNodes(audioPlayerNode, echoNode, audioEngine.outputNode)
        }
        
        else if (effect == "reverb"){
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.Cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attachNode(reverbNode)
            connectNodes(audioPlayerNode, reverbNode, audioEngine.outputNode)
        }
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }
        catch {
            
        }
        
        audioPlayerNode.play()
    }
    
    //Used from Udacity File 
    func connectNodes(nodes: AVAudioNode...){
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
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
    }
    


}
