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
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: recordedAudio.filePathURL)
        } catch {
            
        }
        self.audioPlayer.play()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(PlaySoundsViewController.updateSliderLocation), userInfo: nil, repeats: true)
        
        slider.maximumValue = Float(self.audioPlayer.duration)
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
        configureUI(.Playing)
        switch (ButtonType(rawValue: sender.tag)!) {
            case .Slow:
                playSound(rate: 0.5)
                break
            case .Fast:
                playSound(rate: 1.5)
                break
            case .Chipmunk:
                playSound(pitch: 1000)
                break
            case .Vader:
                playSound(pitch: -1000)
                break
            case .Echo:
                playSound(echo: true)
                break
            case .Reverb:
                playSound(reverb: true)
                break
        }
    }
    
    @IBAction func stopPlayButton(sender: UIButton) {
        configureUI(.NotPlaying)
        stopAudio()
    }
    
    override func viewWillAppear(animated: Bool) {
        configureUI(.NotPlaying)
    }

    @IBAction func scrollThroughAudio(sender: AnyObject) {
        self.audioPlayer.stop()
        self.audioPlayer.currentTime = NSTimeInterval(slider.value)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    func updateSliderLocation() {
        slider.value = Float(self.audioPlayer.currentTime)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
