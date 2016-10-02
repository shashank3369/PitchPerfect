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

    @IBAction func recordAudio(_ sender: AnyObject) {
        adjustUI(true)
        pauseButton.isEnabled = true
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let recordingName = "recordedVoice.wav"
        let filePath = documentsUrl.appendingPathComponent(recordingName)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        adjustUI(false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func adjustUI(_ recording: Bool) {
        stopRecordButton.isEnabled = recording
        recordButton.isEnabled = !recording
        recordingLabel.text = recording ? "Recording in Progress" : "Tap To Record"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecordButton.isEnabled = false
        pauseButton.isEnabled = false
        resumeButton.isEnabled = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayback)
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            showAlert("Recording Failed")
        }
    }
    
    @IBAction func pauseRecording(_ sender: AnyObject) {
        audioRecorder.pause()
        pauseButton.isEnabled = false
        resumeButton.isEnabled = true
    }
    
    @IBAction func resumeRecording(_ sender: AnyObject) {
        audioRecorder.record()
        pauseButton.isEnabled = true
        resumeButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            
            let recordedAudioURL = sender as! URL
            let newRecordedObject = RecordedObject(url: recordedAudioURL, name: Date().description)
            playSoundsVC.recordedAudio = newRecordedObject
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

