//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Christopher Feltner on 3/25/17.
//  Copyright © 2017 Christopher Feltner. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var soundNameTextField: UITextField!
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setUpRecorder()
    {
        do{
        //create audio session
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.overrideOutputAudioPort(.speaker)
        try session.setActive(true)
        //create audio settings
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
        
        //create file URL
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
        
        //create audio recorder object
        audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        }
        catch let error as NSError{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRecordPressed(_ sender: Any) {
        if audioRecorder!.isRecording
        {
            //stop recording
            audioRecorder!.stop()
            //change button title to record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }
        else
        {
            //begin recording
            audioRecorder!.record()
            
            //change button title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }

    @IBAction func onPlayPressed(_ sender: Any) {
        do{
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }
        catch{
            
        }
    }

    @IBAction func onAddPressed(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = soundNameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
        
    }

}
