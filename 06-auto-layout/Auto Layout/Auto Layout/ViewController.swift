//
//  ViewController.swift
//  Auto Layout
//
//  Created by Brian Sipple on 1/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let labelViews = [
        "label1": UILabel(),
        "label2": UILabel(),
        "label3": UILabel(),
        "label4": UILabel(),
        "label5": UILabel(),
    ]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createViews()
        addViewConstraints()
    }
    
    
    func createViews() {
        labelViews["label1"]?.backgroundColor = UIColor.red
        labelViews["label1"]?.text = "THESE"
        
        labelViews["label2"]?.backgroundColor = UIColor.cyan
        labelViews["label2"]?.text = "ARE"
        
        labelViews["label3"]?.backgroundColor = UIColor.yellow
        labelViews["label3"]?.text = "SOME"
        
        labelViews["label4"]?.backgroundColor = UIColor.orange
        labelViews["label4"]?.text = "AWESOME"
        
        labelViews["label5"]?.backgroundColor = UIColor.purple
        labelViews["label5"]?.text = "LABELS"

        
        for label in labelViews.values {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            view.addSubview(label)
        }
    }
    
    
    func addViewConstraints() {
        for labelKey in labelViews.keys {
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[\(labelKey)]|",
                    options: [],
                    metrics: nil,
                    views: labelViews
                )
            )
        }
        
        /*
            📝 By ommitting the ending "|", we're leaving whitespace past the last label,
            instead of forcing it to stretch to the bottom edge of the view
        */
        let layouString = "V:|" + (1...5).map({ "[label\($0)]" }).joined(separator: "-")
        
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: layouString,
                options: [],
                metrics: nil,
                views: labelViews
            )
        )
    }
    
    


}

