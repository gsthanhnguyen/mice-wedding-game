//
//  Lose_Level02.swift
//  mice_wedding
//
//  Created by Thanh Nguyen on 2023-04-13.
//

import SpriteKit

public class  Lose_Level02: SKScene {
    var Lose_button: SKSpriteNode!
    var Lose_background: SKSpriteNode!
    
    override public func didMove(to view: SKView) {     
        print("Level 2 Lose scene loaded")
        Lose_background = childNode(withName: "Lose02_background") as? SKSpriteNode
        Lose_background.zPosition = -1

        // Create button node
        Lose_button = childNode(withName: "Lose02_button") as? SKSpriteNode
        Lose_button.zPosition = 1
    }
    
    // handle touch event when user click on the button
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)
            if Lose_button.frame.contains(touchLocation) {
                let nextScene = N09_Level02Gameplay_OnGrass(fileNamed: "N09_Level02Gameplay_OnGrass")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
    
}

