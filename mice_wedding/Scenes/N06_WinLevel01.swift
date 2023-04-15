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
    
    override public func didMove(to view: SKView) {     
        // animation fading in and out
        let fadeIn = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1)
        let flash = SKAction.sequence([fadeIn, fadeOut])
        let repeatFlash = SKAction.repeatForever(flash) // call this action to make the node fade in and out continuously        

        N06_background = childNode(withName: "N06_background") as? SKSpriteNode
        N06_background.zPosition = -1

        // Create button node
        N06_button = childNode(withName: "N06_button") as? SKSpriteNode
        N06_button.zPosition = 1
        N06_button.run(repeatFlash)


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
