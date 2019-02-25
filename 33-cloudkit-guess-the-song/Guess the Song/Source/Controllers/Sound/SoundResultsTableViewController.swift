//
//  SoundResultsTableViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit


class SoundResultsTableViewController: UITableViewController {
    let cellReuseIdentifier = "Cell"

    var soundBite: SoundBite!
    var suggestions: [String] = []
    
    lazy var publicCloudDatabase = CKContainer.default().publicCloudDatabase
    lazy var soundPlayer = makeSoundPlayer()
    lazy var suggestionsQuery = makeSuggestionsQuery()
    lazy var downloadButton = makeDownloadButton()
    lazy var downloadSpinner = makeDownloadSpinner()
    lazy var listenButton = makeListenButton()
    
    var soundBiteReference: CKRecord.Reference {
        return CKRecord.Reference(recordID: soundBite.recordID, action: .deleteSelf)
    }
    
    enum DownloadState {
        case inProgress
        case inactive
        case finishedSuccessfully
    }
    
    var currentDownloadState = DownloadState.inactive {
        didSet {
            onDownloadStateChanged()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        setupNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadSuggestions()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    /**
     The second section is going to have as many rows as there are suggestions,
     with one extra: a row that says "Add suggestion" so that users
     can tap that and suggest their own matches for the song.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return suggestions.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
     
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: indexPath.section == 0 ? .title2 : .body)

        if indexPath.section == 0 {
            cell.textLabel?.text = soundBite.comments.isEmpty ? "No Comments Yet" : soundBite.comments
            
        } else {
            // Only our "Add suggestion" row will repsond to taps
            if indexPath.row == suggestions.count {
                cell.selectionStyle = .gray
                cell.textLabel?.text = "Add Suggestion"
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = #colorLiteral(red: 0.4665188789, green: 0.4245759249, blue: 0.8790055513, alpha: 1)
            } else {
                cell.textLabel?.text = suggestions[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Comments/Hints"
        }
        
        if section == 1 {
            return "Suggested Songs"
        }
        
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 && indexPath.row == suggestions.count  else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertController = UIAlertController(title: "Suggest a Song", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) {
            [unowned self, alertController] action in
            guard let textField = alertController.textFields?.first else {
                return
            }
            
            if !textField.text!.isEmpty {
                self.add(suggestion: textField.text!)
            }
        })
        
        present(alertController, animated: true)
    }
    
    
    // MARK: - Helper functions
    
    func add(suggestion: String) {
        let suggestionRecord = CKRecord(recordType: AppCKRecordType.suggestions)
        
        suggestionRecord["text"] = suggestion as CKRecordValue
        suggestionRecord["owningSoundBite"] = soundBiteReference as CKRecordValue
        
        save(suggestion: suggestionRecord)
    }
    
    
    func save(suggestion: CKRecord) {
        publicCloudDatabase.save(suggestion) { [unowned self] (suggestionRecord: CKRecord?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    self.displayBasicAlert(
                        title: "Uh-oh",
                        message: "An error occurred while trying to save your suggestion:\n\(error.localizedDescription)\nPlease try again."
                    )
                } else {
                    guard
                        let suggestionRecord = suggestionRecord,
                        let suggestionText = suggestionRecord["text"] as? String
                        else {
                            fatalError("Bad record data retruned after saving")
                    }

                    self.suggestions.append(suggestionText)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setupNavbar() {
        title = "Genre: \(soundBite.genre)"
        navigationItem.rightBarButtonItem = downloadButton
    }
    
    func loadSuggestions() {
        publicCloudDatabase.perform(suggestionsQuery, inZoneWith: nil) {
            [unowned self] (suggestions: [CKRecord]?, error: Error?) in
                if let error = error {
                    self.displayBasicAlert(title: "Error while loading suggestions:\n\(error.localizedDescription)")
                } else {
                    if let suggestions = suggestions {
                        self.parseSuggestionResults(suggestions)
                    }
                }
        }
    }
    
    func parseSuggestionResults(_ suggestions: [CKRecord]) {
        let newSuggestions = suggestions.reduce([String]()) { accumulated, suggestion in
            if let suggestionText = suggestion["text"] as? String {
                return accumulated + [suggestionText]
            }
            return accumulated
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.suggestions = newSuggestions
            self.tableView.reloadData()
        }
    }
    
    
    
    @objc func downloadButtonTapped() {
        currentDownloadState = .inProgress
        
        publicCloudDatabase.fetch(withRecordID: soundBite.recordID) {
            [unowned self] (fullSoundBiteRecord: CKRecord?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    self.displayBasicAlert(title: "Error while downloading sound bite", message: "\(error.localizedDescription)", onClose: { _ in
                        self.currentDownloadState = .inactive
                    })
                } else {
                    guard let fullSoundBiteRecord = fullSoundBiteRecord else {
                        fatalError("Unreadable soundbite record data")
                    }
                    
                    if let audioAsset = fullSoundBiteRecord["audio"] as? CKAsset {
                        self.soundBite.audio = audioAsset.fileURL
                        self.currentDownloadState = .finishedSuccessfully
                    } else {
                        self.displayBasicAlert(title: "Sound bite audio file not found", message: "You may want to try again.", onClose: { _ in
                            self.currentDownloadState = .inactive
                        })
                    }
                }
            }
        }
    }
    
    
    @objc func listenButtonTapped() {
        do {
            print("Playing audio at file: \(soundBite.audio.absoluteString)")
            let audioPlayer = try AVAudioPlayer(contentsOf: soundBite.audio)
            audioPlayer.play()
        } catch {
            displayBasicAlert(title: "Playback failed", message: "There was a problem playing your sound bite. Please try re-recording")
        }
    }
    
    
    func onDownloadStateChanged() {
        switch currentDownloadState {
        case .inactive:
            downloadSpinner.stopAnimating()
            navigationItem.rightBarButtonItem = downloadButton
        case .inProgress:
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: downloadSpinner)
            downloadSpinner.startAnimating()
        case .finishedSuccessfully:
            downloadSpinner.stopAnimating()
            navigationItem.rightBarButtonItem = listenButton
        }
    }
    
    
    // MARK: - Private functions
    
    private func makeSoundPlayer() -> AVAudioPlayer? {
        do {
            return try AVAudioPlayer(contentsOf: soundBite.audio)
        } catch {
            displayBasicAlert(title: "Error during playback")
        }
        
        return nil
    }
    
    private func makeDownloadButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadButtonTapped))
    }
    
    private func makeSuggestionsQuery() -> CKQuery {
        let predicate = NSPredicate(format: "owningSoundBite == %@", soundBiteReference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: AppCKRecordType.suggestions, predicate: predicate)
        
        query.sortDescriptors = [sort]
        
        return query
    }
    
    private func makeDownloadSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .gray)
        
        spinner.tintColor = UIColor.black
        spinner.hidesWhenStopped = true
        
        return spinner
    }
    
    private func makeListenButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(listenButtonTapped))
    }
}
