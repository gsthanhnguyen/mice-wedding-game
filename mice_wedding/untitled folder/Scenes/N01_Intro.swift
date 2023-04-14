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
    var N01_cat: SKSpriteNode!
    var N01_mice: SKSpriteNode!
    var N01_background: SKSpriteNode!
    var sound: SKAudioNode!
    
    override public func didMove(to view: SKView) {     
        // animation fading in and out
        let fadeIn = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1)
        let flash = SKAction.sequence([fadeIn, fadeOut])
        let repeatFlash = SKAction.repeatForever(flash) // call this action to make the node fade in and out continuously
        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.5), SKAction.moveBy(x: 0, y: -20, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        
        N01_background = childNode(withName: "N01_background") as? SKSpriteNode
        N01_background.zPosition = -1
        // Create button node
        buttonScene_01 = childNode(withName: "N01_button") as? SKSpriteNode
        buttonScene_01.zPosition = 1
        buttonScene_01.run(repeatFlash)

        N01_cat = childNode(withName: "N01_cat") as? SKSpriteNode
        N01_cat.zPosition = 1
        N01_cat.run(moveUpDownContinuously)

        N01_mice = childNode(withName: "N01_mice") as? SKSpriteNode
        N01_mice.zPosition = 1
        N01_mice.run(moveUpDownContinuously)
        
        // Sound credit: Music from #Uppbeat (free for Creators!):https://uppbeat.io/t/soundroll/the-incident
        // License code: ZZ1XRJ9UWQ5JTVUD
        self.run(SKAction.playSoundFileNamed("Sound.mp3", waitForCompletion: false))

    }
    
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
