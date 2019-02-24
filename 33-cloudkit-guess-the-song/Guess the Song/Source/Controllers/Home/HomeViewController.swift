//
//  ViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func addSound(_ sender: Any) {
        let vc = RecordSoundViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

