//
//  ViewController.swift
//  ESP Tester
//
//  Created by Brian Sipple on 3/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var cardContainer: UIView!
    
    enum CardState {
        case allFlat
        case flipping
    }
    
    
    // MARK: - Instance Properties
    
    var currentCardState = CardState.allFlat
    var cardViewControllers: [CardViewController] = []
    
    lazy var cardPositions = makeCardPositions()
    lazy var cardImages = makeCardImages()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadCards()
    }
    
    
    // MARK: - Methods
    
    @objc func loadCards() {
        removeCardsInView()
        cardImages.shuffle()
        
        for (index, position) in cardPositions.enumerated() {
            let cardViewController = CardViewController()
            let cardImage = cardImages[index]
            
            cardViewController.delegate = self
            
            // use view controller containment...
            addChild(cardViewController)
            
            // ...AND add the VC's view to our container view
            cardContainer.addSubview(cardViewController.view)
            cardViewController.didMove(toParent: self)
            
            cardViewController.view.center = position
            cardViewController.frontImageView.image = cardImage
            
            // if the new card is a star, mark is as "correct"
            if cardImage.accessibilityIdentifier == "star" {
                cardViewController.isCorrect = true
            }
            
            cardViewControllers.append(cardViewController)
        }
        
        currentCardState = .allFlat
    }
    
    func removeCardsInView() {
        for card in cardViewControllers {
            card.view.removeFromSuperview()
            card.removeFromParent()
        }
        
        cardViewControllers.removeAll(keepingCapacity: true)
    }
    
    
    // MARK: - Event handling
    
    func cardTapped(_ tappedCard: CardViewController) {
        guard currentCardState == .allFlat else { return }
        
        currentCardState = .flipping
        
        for card in cardViewControllers {
            if card == tappedCard {
                card.flipToReveal()
                card.perform(#selector(card.fadeAway), with: nil, afterDelay: 1)
            } else {
                card.fadeAway()
            }
        }
        
        perform(#selector(loadCards), with: nil, afterDelay: 2)
    }
    
    
    // MARK: - Private functions
    
    private func makeCardPositions() -> [CGPoint] {
        let cardWidth = Dimension.Card.width
        let cardHeight = Dimension.Card.height
        let xSpacing = 10
        let ySpacing = 10
        
        var positions: [CGPoint] = []
        
        for row in 0...1 {
            let yPos = (cardHeight / 2) + (cardHeight * row) + (ySpacing * row) + 15
            
            positions += [
                CGPoint(x: (cardWidth / 2) + (cardWidth * 0) + (xSpacing * 1) + 15, y: yPos),
                CGPoint(x: (cardWidth / 2) + (cardWidth * 1) + (xSpacing * 2) + 15, y: yPos),
                CGPoint(x: (cardWidth / 2) + (cardWidth * 2) + (xSpacing * 3) + 15, y: yPos),
                CGPoint(x: (cardWidth / 2) + (cardWidth * 3) + (xSpacing * 4) + 15, y: yPos),
            ]
        }
        
        return positions
    }
    
    
    private func makeCardImages() -> [UIImage] {
        return [
            "Circle", "Circle", "Cross", "Cross", "Lines", "Lines", "Square", "Star"
        ].map {
            let image = UIImage(named: "card\($0)")!
            image.accessibilityIdentifier = $0
            
            return image
        }
    }
}

