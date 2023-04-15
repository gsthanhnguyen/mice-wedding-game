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
    var N04_background: SKSpriteNode!
    var backgroundMusic: SKAudioNode!
    var mice: [SKSpriteNode] = []
    
    override public func didMove(to view: SKView) {
        // stop current sound and play new sound for this Scene
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.backgroundMusicManager.updateSound_Level01()
        }        
        
        // // animation fading in and out
        // let fadeIn = SKAction.fadeAlpha(to: 0, duration: 0.5)
        // let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1)
        // let flash = SKAction.sequence([fadeIn, fadeOut])
        // let repeatFlash = SKAction.repeatForever(flash) // call this action to make the node fade in and out continuously        
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.5), SKAction.moveBy(x: 0, y: -20, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
        let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)

        // Create the background node
        N04_background = childNode(withName: "N04_background") as? SKSpriteNode
        N04_background.zPosition = -1


        // Create button node
        N04_button = childNode(withName: "N04_button") as? SKSpriteNode
        N04_button.zPosition = 4
        // N04_button.run(repeatFlash)

        for child in self.children {
            if child.name == "cloud" {
                if let child = child as? SKSpriteNode {
                    // animation move right to left for clouds
                    child.zPosition = -1
                    // let moveLeft = SKAction.moveBy(x: -self.frame.width - child.size.width, y: 0, duration: 5) // move left
                    // let resetPosition = SKAction.run {child.position = CGPoint(x: self.frame.width + child.size.width/2, y: self.frame.midY)} // reset position
                    // let sequence = SKAction.sequence([moveLeft, resetPosition])
                    // let repeatForever = SKAction.repeatForever(sequence)
                    child.run(moveLeftRightContinuously)
                    // clouds.append(child)
                }
            } else if child.name == "mouse" {
                    if let child: SKSpriteNode = child as? SKSpriteNode {
                        // animation move right to left for clouds
                        child.zPosition = 5
                        child.run(moveUpDownContinuously)
                        mice.append(child)
                    }
            }
        }
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
