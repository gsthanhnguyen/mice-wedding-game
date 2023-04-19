//
//  LevelDecision.swift
//  mice_wedding
//
//  Created by Thanh Nguyen on 2023-04-13.
//

import SpriteKit

/*
    this class is to manage the scene when player wins or lose the game
*/

public class LevelDecision: SKScene {
    var didWin: Bool
    var currentLevel: Int
    let transition = SKTransition.fade(withDuration: 1.0) // transition between scenes

    // init the scene
    init(didWin: Bool, jumpToLevel: Int, size: CGSize) {
        self.didWin = didWin
        self.currentLevel = jumpToLevel
        super.init(size: size)
        scaleMode = .aspectFill
    }

    // this is required for the init to work
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didMove(to view: SKView) {
        print("Level Decision functionality loaded")
    
        self.removeAllActions() // remove all actions
        
        if !didWin {
            // if player lose the game in level 1
            if currentLevel == 1 {
                if let nextScene = Lose_Level01(fileNamed: "Lose_Level01"){
                    nextScene.scaleMode = .aspectFit
                    view.presentScene(nextScene, transition: transition)
                }
            }
            
            // if player lose the game in level 2
            if currentLevel == 2 {
                if let nextScene = Lose_Level02(fileNamed: "Lose_Level02") {
                    nextScene.scaleMode = .aspectFit
                    view.presentScene(nextScene, transition: transition)
                }
            }
        } else if didWin {
            // if player win the game in level 1
            if currentLevel == 1 {
                if let nextScene = N06_WinLevel01(fileNamed: "N06_WinLevel01") {
                    nextScene.scaleMode = .aspectFit
                    view.presentScene(nextScene, transition: transition)
                }
            }
            
            // if player win the game in level 2
            if currentLevel == 2 {
                if let nextScene = N10_FinalWin(fileNamed: "N10_FinalWin") {
                    nextScene.scaleMode = .aspectFit
                    view.presentScene(nextScene, transition: transition)
                }
            }
        }
    }
}
