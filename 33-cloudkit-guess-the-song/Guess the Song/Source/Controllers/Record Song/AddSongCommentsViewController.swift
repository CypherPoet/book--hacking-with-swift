//
//  AddSongCommentsViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class AddSongCommentsViewController: UIViewController {
    var genre: SelectGenreTableViewController.Genre! = nil
    
    let placeholderText = """
        If you have any additional comments that might help identify your song,
        please enter then here.
        """
    
    lazy var commentsTextView = makeCommentsTextView()

    var isShowingPlaceholder = true {
        didSet {
            commentsTextView.text = isShowingPlaceholder ? placeholderText : ""
        }
    }
    
    override func loadView() {
        createView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavbar()
        commentsTextView.text = placeholderText
    }
    
    
    func createView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.addSubview(commentsTextView)
        
        commentsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        commentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        commentsTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        commentsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    func setupNavbar() {
        title = "Song Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonTapped))
    }
    
    @objc func submitButtonTapped() {
        let viewController = SubmitViewController()
        
        viewController.genre = genre
        viewController.comments = isShowingPlaceholder ? "" : commentsTextView.text
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func makeCommentsTextView() -> UITextView {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        return textView
    }
}


extension AddSongCommentsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isShowingPlaceholder {
            isShowingPlaceholder = false
        }
    }
}
