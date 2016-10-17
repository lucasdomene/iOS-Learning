//
//  ViewController.swift
//  AudioDemo
//
//  Created by Simon Ng on 21/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var stopButton:UIButton!
    @IBOutlet weak var recordButton:UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.isEnabled = false
        playButton.isEnabled = false
        
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            let alertMessage = UIAlertController(title: "Error", message: "Failed to get the document directory for recording the audio. Please try again later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
        
        let audioFileURL = directoryURL.appendingPathComponent("MyAudioMemo.m4a")
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            
            let recorderSetting: [String: Any] = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                   AVSampleRateKey: 44100.0,
                                   AVNumberOfChannelsKey: 2,
                                   AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print(error)
        }
    }

    @IBAction func play(_ sender: AnyObject) {
    }
    
    @IBAction func stop(_ sender: AnyObject) {
    }
    
    @IBAction func record(_ sender: AnyObject) {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                playButton.setImage(UIImage(named: "play"), for: .normal)
                playButton.isSelected = false
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                    
                    recorder.record()
                    recordButton.setImage(UIImage(named: "recording"), for: .selected)
                    recordButton.isSelected = true
                } catch {
                    print(error)
                }
            } else {
                recorder.pause()
                recordButton.setImage(UIImage(named: "pause"), for: .normal)
                recordButton.isSelected = false
            }
        }
        
        stopButton.isEnabled = true
        playButton.isEnabled = false
    }
    
}

