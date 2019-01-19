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
        
        let metrics = ["labelHeight": 88]
        
        /*
         Auto Layout VFL string with the following constraints:
            - Each of the 5 labels should be "(labelHeight)" points high.
            - The bottom of our last label must be at least 10 points away from the
              bottom of the view controller's view.
         
         📝 When specifying the size of a space, we need to use the "-" before and
            after the size: a simple space, "-", becomes "-(>=10)-".
        */
        let layouString = "V:|" + (1...5).map({ "[label\($0)(labelHeight)]" }).joined(separator: "-") + "-(>=10)-|"
        
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: layouString,
                options: [],
                metrics: metrics,
                views: labelViews
            )
        )
    }
    
    


}

