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
    
    enum RecordingState {
        case inactive
        case recording
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
        title = "Record Your Song 🎤"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        setupRecording()
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
        } catch let error {
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
}
