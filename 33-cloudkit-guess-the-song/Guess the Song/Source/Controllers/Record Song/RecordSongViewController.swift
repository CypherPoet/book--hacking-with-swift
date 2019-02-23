//
//  RecordSongViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSongViewController: UIViewController {
    lazy var stackView = makeStackView()
    lazy var recordingSession = AVAudioSession.sharedInstance()
    lazy var recordButton = makeRecordButton()
    lazy var failureLabel = makeFailureLabel()
    lazy var songRecorder: AVAudioRecorder? = makeRecorder()
    
    var submitRecordingButton: UIBarButtonItem!
    
    enum RecordingState {
        case inactive
        case recording
        case finishedSuccessfully
        case finishedUnsuccessfully
    }
    
    var currentRecordingState = RecordingState.inactive {
        didSet {
            recordingStateChanged()
        }
    }


    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.gray
        view.addSubview(stackView)
        
        positionStackView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavbar()
        setupRecording()
    }
    
    
    func setupNavbar() {
        title = "Record Your Song 🎤"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        
        submitRecordingButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(submitButtonTapped))
        submitRecordingButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = submitRecordingButton
    }
    
    
    func setupRecording() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadRecordFailedUI()
                    }
                }
            }
        } catch {
            loadRecordFailedUI()
        }
    }
    
    
    func loadRecordingUI() {
       stackView.addArrangedSubview(recordButton)
    }
    
    
    func loadRecordFailedUI() {
        stackView.addArrangedSubview(failureLabel)
    }
    
    
    func positionStackView() {
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    @objc func recordTapped() {
        switch currentRecordingState {
        case .recording:
            songRecorder?.stop()
        default:
            currentRecordingState = .recording
            songRecorder?.record()
        }
    }

    @objc func submitButtonTapped() {
        
    }
    

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        
        return stackView
    }
    
    
    func makeRecordButton() -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap to Record", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
        return button
    }
    
    
    func makeFailureLabel() -> UILabel {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Recording failed. Please make sure the app has access to your microphone"
        label.numberOfLines = 0
        
        return label
    }
    
    
    func makeRecorder() -> AVAudioRecorder? {
        let songPath = UIViewController.getSongURL()
        print("URL for recorded song: \(songPath.absoluteString)")
        
        let recorderSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let recorder = try AVAudioRecorder(url: songPath, settings: recorderSettings)
            recorder.delegate = self
            
            return recorder
        } catch {
            self.currentRecordingState = .finishedUnsuccessfully
        }
        
        return nil
    }
    
    
    func recordingStateChanged() {
        let animationDuration = 0.25
        
        switch currentRecordingState {
        case .recording:
            UIView.animate(
                withDuration: animationDuration,
                animations: { [unowned self] in
                    self.view.backgroundColor = #colorLiteral(red: 0.79293257, green: 0.2189754248, blue: 0.2273216546, alpha: 1)
                },
                completion: { [unowned self] _ in
                    self.recordButton.setTitle("Tap to Stop", for: .normal)
                    self.submitRecordingButton.isEnabled = false
                }
            )
        case .inactive:
            UIView.animate(
                withDuration: animationDuration,
                animations: { [unowned self] in
                    self.view.backgroundColor = #colorLiteral(red: 0.3365412951, green: 0.3497310877, blue: 0.5033047199, alpha: 1)
                },
                completion: { [unowned self] _ in
                    self.recordButton.setTitle("Tap to Record", for: .normal)
                    self.submitRecordingButton.isEnabled = true
                }
            )
        case .finishedSuccessfully:
            UIView.animate(
                withDuration: animationDuration,
                animations: { [unowned self] in
                    self.view.backgroundColor = #colorLiteral(red: 0, green: 0.7464764714, blue: 0.310388267, alpha: 1)
                },
                completion: { [unowned self] _ in
                    self.recordButton.setTitle("Tap to Re-Record", for: .normal)
                    self.submitRecordingButton.isEnabled = true
                }
            )
        case .finishedUnsuccessfully:
            let alertController = UIAlertController(
                title: "Record failed.",
                message: "There was a problem recording your song. Please try again.",
                preferredStyle: .alert
            )
            
            alertController.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { [unowned self] (UIAlertAction) -> Void in
                        self.currentRecordingState = .inactive
                    }
                )
            )
            
            present(alertController, animated: true)
        }
    }
}


extension RecordSongViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        currentRecordingState = flag ? .finishedSuccessfully : .finishedUnsuccessfully
    }
}
