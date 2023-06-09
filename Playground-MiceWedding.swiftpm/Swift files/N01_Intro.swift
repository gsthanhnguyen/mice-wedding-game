//
//  01_Intro.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import Foundation
import SpriteKit

public class N01_Intro: SKScene {

    var buttonScene_01: SKSpriteNode!
    var N01_background: SKSpriteNode!
    var N01_logo: SKSpriteNode!
    var mice: [SKSpriteNode] = []
    
    override public func didMove(to view: SKView) {
        print("Initiate the first game scene successfully")
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.5), SKAction.moveBy(x: 0, y: -20, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
        let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)
        
        N01_background = childNode(withName: "N01_background") as? SKSpriteNode
        N01_background.zPosition = -5

        // Create button node
        buttonScene_01 = childNode(withName: "N01_button") as? SKSpriteNode
        buttonScene_01.zPosition = 5

        for child in self.children {
            if child.name == "cloud" {
                if let child = child as? SKSpriteNode {
                    child.zPosition = -1
                    child.run(moveLeftRightContinuously)
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
            
            if buttonScene_01.frame.contains(touchLocation) {
                let nextScene = N02_OriginalStory(fileNamed: "N02_OriginalStory")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
    }
}
