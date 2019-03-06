//
//  CardViewController.swift
//  ESP Tester
//
//  Created by Brian Sipple on 3/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    // MARK: - Instance Properties
    
    weak var delegate: HomeViewController!
    
    lazy var frontImageView = makeFrontImageView()
    lazy var backImageView = makeBackImageView()
    
    var isCorrect = false
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bounds = CGRect(x: 0, y: 0, width: Dimension.Card.width, height: Dimension.Card.height)
        
        view.addSubview(frontImageView)
        view.addSubview(backImageView)
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.backImageView.alpha = 1
        })
    }
    
    
    // MARK: - Event handling
    
    @objc func cardTapped(_ sender: UIGestureRecognizer) {
        delegate.cardTapped(self)
    }

    @objc func flipToReveal() {
        UIView.transition(
            with: view,
            duration: 0.7,
            options: [.transitionFlipFromRight],
            animations: { [weak self] in
                self?.backImageView.isHidden = true
                self?.frontImageView.isHidden = false
            }
        )
    }
    
    
    @objc func fadeAway() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001) // shrink down
            self?.view.alpha = 0
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Private functions
    
    private func makeFrontImageView() -> UIImageView {
        let imageView = makeCardImageView()
        
        imageView.isHidden = true
        
        return imageView
    }
    
    
    private func makeBackImageView() -> UIImageView {
        let imageView = makeCardImageView()
        
        imageView.alpha = 0
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
        
        return imageView
    }

    
    private func makeCardImageView() -> UIImageView {
        guard let image = UIImage(named: "cardBack") else {
            fatalError("Failed to load card image assets")
        }
        
        let imageView = UIImageView(image: image)
        
        return imageView
    }
}
