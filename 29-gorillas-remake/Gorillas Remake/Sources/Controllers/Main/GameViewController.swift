//
//  GameViewController.swift
//  Gorillas Remake
//
//  Created by Brian Sipple on 2/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


enum GameplayState {
    case awaitingThrow
    case throwing
}

enum CurrentPlayer {
    case playerOne
    case playerTwo
}

class GameViewController: UIViewController {
    @IBOutlet weak var throwAngleSlider: UISlider!
    @IBOutlet weak var throwAngleLabel: UILabel!
    
    @IBOutlet weak var throwVelocitySlider: UISlider!
    @IBOutlet weak var throwVelocityLabel: UILabel!
    
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var playerIndicator: UILabel!
    
    var gameScene: GameScene!
    
    lazy var uiControls = [throwAngleSlider, throwAngleLabel, throwVelocityLabel, throwVelocitySlider, launchButton]
    
    var currentThrowAngle = 45 {
        didSet {
            throwAngleLabel.text = "Angle: \(currentThrowAngle)°"
        }
    }
    
    var currentThrowVelocity = 125 {
        didSet {
            throwVelocityLabel.text = "Velocity: \(currentThrowVelocity)"
        }
    }
    
    var currentPlayer = CurrentPlayer.playerOne {
        didSet {
            switch currentPlayer {
            case .playerOne:
                playerIndicator.text = "<<< PLAYER ONE"
            case .playerTwo:
                playerIndicator.text = "PLAYER TWO >>>"
            }
        }
    }
    
    var gameplayState = GameplayState.awaitingThrow {
        didSet {
            gameplayStateChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let gameScene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                self.gameScene = gameScene
                gameScene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(gameScene)
                gameScene.gameViewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        setupState()
    }
    
    func setupState() {
        angleChanged(throwAngleSlider)
        velocityChanged(throwVelocitySlider)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func gameplayStateChanged() {
        switch gameplayState {
        case .throwing:
            uiControls.forEach({ $0?.isHidden = true })
        case .awaitingThrow:
            uiControls.forEach({ $0?.isHidden = false })
        }
    }
    
    func launchCompleted() {
        gameplayState = .awaitingThrow
        changeCurrentPlayer()
    }
    
    func changeCurrentPlayer() {
        switch currentPlayer {
        case .playerOne:
            currentPlayer = .playerTwo
        case .playerTwo:
            currentPlayer = .playerOne
        }
    }
    
    func sceneTransitioned() {
        
    }
    
    
    @IBAction func angleChanged(_ sender: Any) {
        currentThrowAngle = Int(throwAngleSlider.value)
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        currentThrowVelocity = Int(throwVelocitySlider.value)
    }
    
    @IBAction func launchTapped(_ sender: Any) {
        gameplayState = .throwing
        gameScene.launch(angle: currentThrowAngle, speed: currentThrowVelocity)
    }
}
