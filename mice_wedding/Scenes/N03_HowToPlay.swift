//
//  03_HowToPlay.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import Foundation
import SpriteKit

public class N03_HowToPlay: SKScene {
    var N03_button: SKSpriteNode!
    var N03_mouse: SKSpriteNode!
    var N03_background: SKSpriteNode!

    var moveRight: SKAction!
    var moveLeft: SKAction!
    var rotateBackwards: SKAction!

    
    override public func didMove(to view: SKView) {   
        print("How to play scene loaded")  
        // animation moving left and right
        let moveDistance = CGFloat(800)
        let moveRight = SKAction.moveBy(x: moveDistance, y: 0, duration: TimeInterval(6))
        let flipRight = SKAction.scaleX(to: 3.6, duration: 0)
        let moveLeft = SKAction.moveBy(x: -moveDistance, y: 0, duration: TimeInterval(6))
        let flipLeft = SKAction.scaleX(to: -3.6, duration: 0)
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 7, duration: 0.5), SKAction.moveBy(x: 0, y: -7, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)

        let moveSequence = SKAction.sequence([moveRight, flipLeft, moveLeft, flipRight])

        // Repeat the sequence forever
        let moveBackAndForth = SKAction.repeatForever(moveSequence)
        
        // Create the background node
        N03_background = childNode(withName: "N03_background") as? SKSpriteNode
        N03_background.zPosition = -1

        // Create button node
        N03_button = childNode(withName: "N03_button") as? SKSpriteNode
        N03_button.zPosition = 1
//        N03_button.run(repeatFlash)

        // create mouse node
        N03_mouse = childNode(withName: "N03_mouse") as? SKSpriteNode
        N03_mouse.zPosition = 1
        N03_mouse.run(moveBackAndForth)
        N03_mouse.run(moveUpDownContinuously)
    }
    
    // handle touch event when user click on the button
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            
            let touchLocation = touch.location(in: self)
            
            if N03_button.frame.contains(touchLocation) {
                let nextScene = N04_Level01Intro(fileNamed: "N04_Level01Intro")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
}
