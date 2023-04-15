//
//  04_Level01Intro.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import Foundation
import SpriteKit

public class  N04_Level01Intro: SKScene {
    var N04_button: SKSpriteNode!
    var N04_mouse: SKSpriteNode!
    var N04_cat: SKSpriteNode!
    var N04_tree: SKSpriteNode!
    var N04_house: SKSpriteNode!
    var N04_background: SKSpriteNode!
    var backgroundMusic: SKAudioNode!
    
    override public func didMove(to view: SKView) {
        // stop current sound and play new sound for this Scene
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.backgroundMusicManager.updateSound_Level01()
        }        
        
        // animation fading in and out
        let fadeIn = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1)
        let flash = SKAction.sequence([fadeIn, fadeOut])
        let repeatFlash = SKAction.repeatForever(flash) // call this action to make the node fade in and out continuously        
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.5), SKAction.moveBy(x: 0, y: -20, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // Create the wobbling action
        let duration = 0.4
        let magnitude = 6.0
        let rotateLeft = SKAction.rotate(byAngle: CGFloat(-Double.pi/magnitude), duration: duration/2)
        let rotateRight = SKAction.rotate(byAngle: CGFloat(Double.pi/magnitude), duration: duration/2)
        let wobble = SKAction.repeatForever(SKAction.sequence([rotateLeft, rotateRight]))


        // Create the background node
        N04_background = childNode(withName: "N04_background") as? SKSpriteNode
        N04_background.zPosition = -1

        // Create animation for nodes on Scene
        N04_house = childNode(withName: "N04_house") as? SKSpriteNode
        N04_house.zPosition = 2

        N04_tree = childNode(withName: "N04_tree") as? SKSpriteNode
        N04_tree.zPosition = 1
        N04_tree.run(wobble)

        N04_cat = childNode(withName: "N04_cat") as? SKSpriteNode
        N04_cat.zPosition = 4
        N04_cat.run(moveUpDownContinuously)

        N04_mouse = childNode(withName: "N04_mouse") as? SKSpriteNode
        N04_mouse.zPosition = 4
        N04_mouse.run(moveUpDownContinuously)

        // Create button node
        N04_button = childNode(withName: "N04_button") as? SKSpriteNode
        N04_button.zPosition = 4
        N04_button.run(repeatFlash)
    }
    
    // handle touch event when user click on the button
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            
            let touchLocation = touch.location(in: self)
            
            if N04_button.frame.contains(touchLocation) {
                let nextScene = N05_Level01Gameplay_Village(fileNamed: "N05_Level01Gameplay_Village")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
}
