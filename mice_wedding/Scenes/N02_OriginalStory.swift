//
//  02_OriginalStory.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import Foundation
import SpriteKit

public class N02_OriginalStory: SKScene {
    var N02_button: SKSpriteNode!
    var N02_background: SKSpriteNode!
    
    override public func didMove(to view: SKView) {     
        // animation fading in and out
//        let fadeIn = SKAction.fadeAlpha(to: 0, duration: 0.5)
//        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1)
//        let flash = SKAction.sequence([fadeIn, fadeOut])
//        let repeatFlash = SKAction.repeatForever(flash) // call this action to make the node fade in and out continuously

        N02_background = childNode(withName: "N02_background") as? SKSpriteNode
        N02_background.zPosition = -1

        // Create button node
        N02_button = childNode(withName: "N02_button") as? SKSpriteNode
        N02_button.zPosition = 1
//        N02_button.run(repeatFlash)
    }
    
    // handle touch event when user click on the button
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)
            if N02_button.frame.contains(touchLocation) {
                let nextScene = N03_HowToPlay(fileNamed: "N03_HowToPlay")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
}
