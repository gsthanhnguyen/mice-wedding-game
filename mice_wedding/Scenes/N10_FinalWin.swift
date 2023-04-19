//
//  10_FinalWin.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import SpriteKit

public class  N10_FinalWin: SKScene {
    var N10_button: SKSpriteNode!
    var N10_background: SKSpriteNode!
    var N10_confetti: SKSpriteNode!
    
    override public func didMove(to view: SKView) {
        // play new sound for this scene
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.backgroundMusicManager.updateSound_Win()
            }

        print("Win Level 2 scene loaded")
        // animation for confetti
        let moveAction = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 2.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        let removeAction = SKAction.removeFromParent()
        let confettiAnimation = SKAction.sequence([moveAction, fadeOutAction, removeAction])

        N10_background = childNode(withName: "N10_background") as? SKSpriteNode
        N10_background.zPosition = -1

        // Create button node
        N10_button = childNode(withName: "N10_button") as? SKSpriteNode
        N10_button.zPosition = 2

        N10_confetti = childNode(withName: "N10_confetti") as? SKSpriteNode
        N10_confetti.zPosition = 1
        N10_confetti.run(confettiAnimation)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            
            let touchLocation = touch.location(in: self)
            
            if N10_button.frame.contains(touchLocation) {
                let nextScene = N11_Credit(fileNamed: "N11_Credit")
                nextScene?.scaleMode = .aspectFit
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
}
