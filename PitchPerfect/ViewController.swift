//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Kothapalli on 8/29/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
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
    }

    @IBAction func stopRecording(sender: AnyObject) {
        recordingLabel.text = "Tap to Record"
        stopRecordButton.enabled = false
        recordButton.enabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordButton.enabled = false
    }
}

