//
//  PlaySoundsViewControllerExtension.swift
//  PitchPerfect
//
//  Created by Kothapalli on 9/23/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import AVFoundation

extension PlaySoundsViewController: AVAudioPlayerDelegate {
    
    enum ButtonType: Int { case slow = 0, fast, vader, chipmunk, echo, reverb }

    /* Controlling Speed and Pitch and Effects*/
    func playWithSpeed(_ rate: Float) {
        resetAudio()
        scrubberSlider.maximumValue = Float(audioPlayer.duration)
        audioPlayer.rate = rate
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlaySoundsViewController.updateScrubSlider), userInfo: nil, repeats: true)
        audioPlayer.play()
        
        

    }
    
    func updateScrubSlider() {
        scrubberSlider.value = Float(audioPlayer.currentTime)
    }
    
    func playWithPitch(_ pitch: Float) {
        
        resetAudio()
        restartAudioNode()
        
        
        let pitchChosen = AVAudioUnitTimePitch()
        pitchChosen.pitch = pitch
        audioEngine.attach(pitchChosen)
        
        audioEngine.connect(audioPlayerNode, to: pitchChosen, format: nil)
        audioEngine.connect(pitchChosen, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }
        catch {
            
        }
        
        audioPlayerNode.play()
        
    }
    
    func playWithEffect(_ effect:String) {
        resetAudio()
        
        restartAudioNode()
        
        
        if (effect == "echo") {
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine.attach(echoNode)
            connectNodes(audioPlayerNode, echoNode, audioEngine.outputNode)
        }
            
        else if (effect == "reverb"){
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attach(reverbNode)
            connectNodes(audioPlayerNode, reverbNode, audioEngine.outputNode)
        }
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }
        catch {
            
        }
        
        audioPlayerNode.play()
    }
    
    //Used from Udacity File
    func connectNodes(_ nodes: AVAudioNode...){
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
            audioPlayer = try AVAudioPlayer(contentsOf: recordedAudio.filePathURL as URL)
            audioFile = try AVAudioFile(forReading: recordedAudio.filePathURL as URL)
        } catch {
            
        }
        self.audioPlayer.enableRate = true
    }
    
    
    func resetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func restartAudioNode() {
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)

    }
}
