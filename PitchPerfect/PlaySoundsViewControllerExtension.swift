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
        
        audioPlayer.rate = rate
        
        setupScrubber(max: Float(audioPlayer.duration))
        audioPlayer.play()
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
        
        setupScrubber(max: Float(Double(audioFile.length)/(audioPlayerNode.lastRenderTime?.sampleRate)!))
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
        
        setupScrubber(max: Float(Double(audioFile.length)/(audioPlayerNode.lastRenderTime?.sampleRate)!))
        audioPlayerNode.play()
    }
    
    //Used from Udacity File
    func connectNodes(_ nodes: AVAudioNode...){
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    /* All Scrubber Related Functions */
    func currentTime() -> TimeInterval {
        if let nodeTime: AVAudioTime = audioPlayerNode.lastRenderTime, let playerTime: AVAudioTime = audioPlayerNode.playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
    
    func updateScrubSlider() {
        if (audioPlayer.isPlaying) {
            let currentTimeOfPlayer = Float(audioPlayer.currentTime)
            scrubberSlider.value = currentTimeOfPlayer
            if (currentTimeOfPlayer > scrubberSlider.maximumValue){
                restartScrubber()
            }
        }
        else if (audioPlayerNode.isPlaying){
            let currentTimeOfNode = Float(currentTime())
            scrubberSlider.value = currentTimeOfNode
            if (currentTimeOfNode > scrubberSlider.maximumValue){
                restartScrubber()
            }
        }
    }
    
    func restartScrubber() {
        timer.invalidate()
        scrubberSlider.value = 0
    }
    
    func setupScrubber(max: Float) {
        scrubberSlider.minimumValue = 0.0
        scrubberSlider.maximumValue = max
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlaySoundsViewController.updateScrubSlider), userInfo: nil, repeats: true)
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
