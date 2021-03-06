//
//  ViewController.swift
//  AudioDemo
//
//  Created by Simon Ng on 21/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
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
    
    // IBActions

    @IBAction func play(_ sender: AnyObject) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOf: recorder.url)
                    
                    audioPlayer?.delegate = self
                    audioPlayer?.play()
                    
                    playButton.setImage(UIImage(named: "playing"), for: .selected)
                    playButton.isSelected = true
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        recordButton.setImage(UIImage(named: "record"), for: .normal)
        recordButton.isSelected = false
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.isSelected = false
        
        stopButton.isEnabled = false
        playButton.isEnabled = true
        
        audioRecorder?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
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
    
    // AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let alertMessage = UIAlertController(title: "Finish recording", message: "Successfully recorded the audio!", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
        }
    }
    
    // AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.isSelected = false
        
        let alertMessage = UIAlertController(title: "Finished playing", message: "Finished playing the recording!", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertMessage, animated: true, completion: nil)
    }
    
}

