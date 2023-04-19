//
//  11_Credit.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-12.
//

import SpriteKit


public class  N11_Credit: SKScene {

    var N11_mouse01: SKSpriteNode?
    var N11_mouse02: SKSpriteNode?
    var N11_mouse03: SKSpriteNode?
    var N11_mouse04: SKSpriteNode?
    var mice: [SKSpriteNode]? = []
    var currentNodeIndex: Int = 0

    var N11_background: SKSpriteNode?
    
    override public func didMove(to view: SKView) {
        print("Credit scene loaded")
        N11_mouse01 = childNode(withName: "N11_mouse01") as? SKSpriteNode
        N11_mouse02 = childNode(withName: "N11_mouse02") as? SKSpriteNode
        N11_mouse03 = childNode(withName: "N11_mouse03") as? SKSpriteNode
        N11_mouse04 = childNode(withName: "N11_mouse04") as? SKSpriteNode
        N11_background = childNode(withName: "N11_background") as? SKSpriteNode
        N11_background?.zPosition = -1

        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 10, duration: 0.5), SKAction.moveBy(x: 0, y: -10, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)

        // run the animation for each mouse
        for child: SKNode in self.children {
            if let nodeName = child.name, nodeName.hasPrefix("N11_mouse") { // declare the name of the node in the scene
                child.run(moveUpDownContinuously)
                child.zPosition = 1            
            }
        }
    }
}

