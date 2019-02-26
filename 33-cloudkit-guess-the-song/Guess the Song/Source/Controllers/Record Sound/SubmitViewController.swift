//
//  SubmitViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CloudKit

class SubmitViewController: UIViewController {
    enum SubmitState {
        case inProgress, inactive, submitSucceeded, submitFailed
    }
    
    var genre: Genre!
    var comments: String!
    var saveErrorMessage = ""
    
    lazy var mainView = makeMainView()
    lazy var statusLabel = makeStatusLabel()
    lazy var progressSpinner = makeProgressSpinner()
    lazy var doneButton = makeDoneButton()

    lazy var publicDatabase = CKContainer.default().publicCloudDatabase

    
    var currentSubmitState = SubmitState.inactive {
        didSet {
            submitStateChanged()
        }
    }
    
    var currentBackgroundColor: UIColor {
        switch currentSubmitState {
        case .submitSucceeded:
            return #colorLiteral(red: 0, green: 0.7464764714, blue: 0.310388267, alpha: 1)
        case .submitFailed:
            return #colorLiteral(red: 0.79293257, green: 0.2189754248, blue: 0.2273216546, alpha: 1)
        default:
            return #colorLiteral(red: 0.2512912154, green: 0.2826214135, blue: 0.5264708996, alpha: 1)
        }
    }
    
    var newSoundRecord: CKRecord {
        let soundRecord = CKRecord(recordType: AppCKRecordType.soundBites)
        let soundAsset = CKAsset(fileURL: UIViewController.getSoundURL())
        
        soundRecord["genre"] = genre.rawValue as CKRecordValue
        soundRecord["comments"] = comments as CKRecordValue
        soundRecord["audio"] = soundAsset
        
        return soundRecord
    }
    

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.darkGray
        
        mainView.addArrangedSubview(statusLabel)
        mainView.addArrangedSubview(progressSpinner)
        view.addSubview(mainView)
        
        configureViewConstraints()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = doneButton
        currentSubmitState = .inProgress
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSubmit()
    }
    
    
    @objc func doneButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func performSubmit() {
        let record = newSoundRecord
        
        publicDatabase.save(record) {
            [unowned self] (record: CKRecord?, error: Error?) in
                DispatchQueue.main.async {
                    if let error = error {
                        HomeViewController.hasNewSoundBiteData = false
                        self.saveErrorMessage = "Error during save: \(error.localizedDescription)"
                        self.currentSubmitState = .submitFailed
                    } else {
                        HomeViewController.hasNewSoundBiteData = true
                        self.currentSubmitState = .submitSucceeded
                    }
                }
            }
    }
    
    
    func submitStateChanged() {
        switch currentSubmitState {
        case .inactive:
            doneButton.isEnabled = false
            progressSpinner.stopAnimating()
        case .inProgress:
            progressSpinner.startAnimating()
            statusLabel.text = "Saving..."
            doneButton.title = nil
            doneButton.isEnabled = false
        case .submitSucceeded:
            statusLabel.text = "Sound Saved!"
            progressSpinner.stopAnimating()
            doneButton.title = "Done"
            doneButton.isEnabled = true
        case .submitFailed:
            statusLabel.text = saveErrorMessage
            progressSpinner.stopAnimating()
            doneButton.title = "Done"
            doneButton.isEnabled = true
        }
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.backgroundColor = self.currentBackgroundColor
        }
    }
    

    
    func configureViewConstraints() {
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    

    private func makeMainView() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }
    
    
    private func makeStatusLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Submitting..."
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        return label
    }
    
    
    private func makeProgressSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        return spinner
    }
    
    private func makeDoneButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        return button
    }
}
