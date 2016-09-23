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
    func playWithSpeed(rate: Float) {
        resetAudio()
        
        self.audioPlayer.rate = rate
        self.audioPlayer.play()
    }
    
    
    func playWithPitch(pitch: Float) {
        
        resetAudio()
        restartAudioNode()
        
        
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
        resetAudio()
        
        restartAudioNode()
        
        
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
    
    
    func resetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func restartAudioNode() {
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

    }
}