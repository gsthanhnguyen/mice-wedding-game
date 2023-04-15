//
//  08_Level02Intro.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import SpriteKit

public class  N08_Level02Intro: SKScene {
    var N08_button: SKSpriteNode!
    var N08_mouse: SKSpriteNode!
    var N08_cat: SKSpriteNode!
    var N08_tree: SKSpriteNode!
    var N08_grass: SKSpriteNode!
    var N08_background: SKSpriteNode!

    
    override public func didMove(to view: SKView) {
        // stop current sound and play new sound for this Scene
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.backgroundMusicManager.updateSound_Level02()
            }
        // animation fading in and out
        let fadeIn = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1)
        let flash = SKAction.sequence([fadeIn, fadeOut])
        let repeatFlash = SKAction.repeatForever(flash) // call this action to make the node fade in and out continuously        
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.5), SKAction.moveBy(x: 0, y: -20, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
        let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)

        // Create the background node
        N08_background = childNode(withName: "N08_background") as? SKSpriteNode
        N08_background.zPosition = -1

        N08_cat = childNode(withName: "N08_cat") as? SKSpriteNode
        N08_cat.zPosition = 4
        N08_cat.run(moveUpDownContinuously)

        N08_mouse = childNode(withName: "N08_mouse") as? SKSpriteNode
        N08_mouse.zPosition = 4
        N08_mouse.run(moveUpDownContinuously)

        // Create button node
        N08_button = childNode(withName: "N08_button") as? SKSpriteNode
        N08_button.zPosition = 4
        N08_button.run(repeatFlash)

        // Create nodes for grass and tree
        for child: SKNode in self.children {
            if child.name == "N08_grass" {
                child.run(moveLeftRightContinuously)
                child.zPosition = 1
            } else if child.name == "N08_tree" {
                child.run(moveUpDownContinuously)
                child.zPosition = 3
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
