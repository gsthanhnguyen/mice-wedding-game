//
//  08_Level02Intro.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import SpriteKit

public class  N08_Level02Intro: SKScene {
    var N08_button: SKSpriteNode!
    var N08_background: SKSpriteNode!
    var mice: [SKSpriteNode] = []
    var N04_bigcat: SKSpriteNode!
    var N04_road: SKSpriteNode!

    
    override public func didMove(to view: SKView) {
        // stop current sound and play new sound for this Scene
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.backgroundMusicManager.updateSound_Level02()
            }
        print("Level 2 Intro scene loaded")
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.5), SKAction.moveBy(x: 0, y: -20, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
        let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)
        // animation moving for clouds
        let cloudDuration: TimeInterval = 10
        let cloudDistance: CGFloat = 600
        let moveCloudsLeftToRight = SKAction.moveBy(x: cloudDistance, y: 0, duration: cloudDuration)
        let moveCloudsRightToLeft = SKAction.moveBy(x: -cloudDistance, y: 0, duration: cloudDuration)
        let moveCloudsRightLeft = SKAction.sequence([moveCloudsLeftToRight,moveCloudsRightToLeft])
        let cloudMoving = SKAction.repeatForever(moveCloudsRightLeft)


        // Create the background node
        N08_background = childNode(withName: "N08_background") as? SKSpriteNode
        N08_background.zPosition = -1

        // Create button node
        N08_button = childNode(withName: "N08_button") as? SKSpriteNode
        N08_button.zPosition = 4
        // N08_button.run(repeatFlash)

        N04_bigcat = childNode(withName: "N04_bigcat") as? SKSpriteNode
        N04_bigcat.zPosition = 5
        N04_bigcat.run(moveUpDownContinuously)

        N04_road = childNode(withName: "N04_road") as? SKSpriteNode
        N04_road.zPosition = 6

        for child in self.children {
            if child.name == "cloud" {
                if let child = child as? SKSpriteNode {
                    child.zPosition = 1
                    child.run(cloudMoving)
                }
            } else if child.name == "mouse" {
                    if let child: SKSpriteNode = child as? SKSpriteNode {
                        // animation move right to left for clouds
                        child.zPosition = 5
                        child.run(moveLeftRightContinuously)
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
            
            if N08_button.frame.contains(touchLocation) {
                let nextScene = N09_Level02Gameplay_OnGrass(fileNamed: "N09_Level02Gameplay_OnGrass")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
}
