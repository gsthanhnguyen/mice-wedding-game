//
//  06_WinLevel01.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import Foundation
import SpriteKit

public class  N06_WinLevel01: SKScene {
    var N06_button: SKSpriteNode!
    var N06_background: SKSpriteNode!
    var N06_confetti: SKSpriteNode!
    
    override public func didMove(to view: SKView) {     
        print("Level 1 Win scene loaded")
        // animation for confetti
        let moveAction = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 2.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        let removeAction = SKAction.removeFromParent()
        let confettiAnimation = SKAction.sequence([moveAction, fadeOutAction, removeAction])

        N06_background = childNode(withName: "N06_background") as? SKSpriteNode
        N06_background.zPosition = -1

        // Create button node
        N06_button = childNode(withName: "N06_button") as? SKSpriteNode
        N06_button.zPosition = 2
//        N06_button.run(repeatFlash)

        N06_confetti = childNode(withName: "N06_confetti") as? SKSpriteNode
        N06_confetti.zPosition = 1
        N06_confetti.run(confettiAnimation)
    }
    
    // handle touch event when user click on the button
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            
            let touchLocation = touch.location(in: self)
            
            if N06_button.frame.contains(touchLocation) {
                let nextScene = N08_Level02Intro(fileNamed: "N08_Level02Intro")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
}
