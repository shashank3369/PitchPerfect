//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Kothapalli on 8/29/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        recordingLabel.text = "Recording in Progress"
        recordButton.enabled = false
        stopRecordButton.enabled = true
        pauseButton.enabled = true
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        recordingLabel.text = "Tap to Record"
        stopRecordButton.enabled = false
        recordButton.enabled = true
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordButton.enabled = false
        pauseButton.enabled = false
        resumeButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else {
            
        }
    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        audioRecorder.pause()
        pauseButton.enabled = false
        resumeButton.enabled = true
    }
    
    @IBAction func resumeRecording(sender: AnyObject) {
        audioRecorder.record()
        pauseButton.enabled = true
        resumeButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            
            let recordedAudioURL = sender as! NSURL
            let newRecordedObject = RecordedObject(url: recordedAudioURL, name: NSDate().description)
            playSoundsVC.recordedAudio = newRecordedObject
        }
    }
}

