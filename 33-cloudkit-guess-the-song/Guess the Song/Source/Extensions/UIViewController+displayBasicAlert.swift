//
//  UIViewController+displayBasicAlert.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayBasicAlert(
        title: String,
        message: String = "",
        onClose onCloseHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: onCloseHandler))
        
        present(alertController, animated: true)
    }
}
