//
//  grass.swift
//  mice-wedding
//
//  Created by Thanh Nguyen on 2023-04-06.
//

import SpriteKit

public class onGrassScene: SKScene, SKPhysicsContactDelegate {
    // start scene
    // set speed for Mice and Cat
    let miceSpeed: CGFloat = 100
    let catSpeed: CGFloat = 120

    // declare objects
    var mice: [SKSpriteNode]? = [] // using array list to manage multiple mouse
    var leadingMouse: SKSpriteNode?
    var cats: [SKSpriteNode] = [] // using array list to manage multiple cats
    var exitHole: SKSpriteNode?

    var lastTouchLocation: CGPoint? = nil

    // set animation for Nodes
    override public func didMove(to view: SKView) {
        // set physics
        physicsWorld.contactDelegate = self

        // set up the exit hole
        exitHole = SKSpriteNode(imageNamed: "exitHole")

        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 10, duration: 0.5), SKAction.moveBy(x: 0, y: -10, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
        let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)
        print("pass moving animation definition")
        // set up the animation for nodes and add them to the array list
        for child: SKNode in self.children {
            if let nodeName = child.name, nodeName.hasPrefix("mouse_") { // declare the name of the node in the scene
                child.run(moveUpDownContinuously)
                mice?.append(child as! SKSpriteNode)
            } else if child.name == "cat" { // declare the name of the node in the scene
                child.run(moveLeftRightContinuously)
                cats.append(child as! SKSpriteNode)
            } 
        }
    }

    // handle touche events and get the location of the touch
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    // get the location of the touch
    fileprivate func handleTouches(_ touches: Set<UITouch>) {
        lastTouchLocation = touches.first?.location(in: self)
    }

    // updating the position and other properties of nodes that are affected by physics
    override public func didSimulatePhysics() {
        updateMice()
        updateCatsChasing()
    }

    fileprivate func updateMice() {
        guard let lastTouchLocation: CGPoint = lastTouchLocation, let mice = mice, let leadingMouse = mice.first
        else {
            return
        }
        let currentPosition: CGPoint = leadingMouse.position
        let xDistance = abs(currentPosition.x - lastTouchLocation.x)
        let yDistance = abs(currentPosition.y - lastTouchLocation.y)
        if xDistance > leadingMouse.frame.width/2 || yDistance > leadingMouse.frame.height/2 {
            mouseMovementUpdating(for: leadingMouse, to: lastTouchLocation, speed: miceSpeed)
        } else {
            leadingMouse.physicsBody?.isResting = true
        }
    }

    fileprivate func mouseMovementUpdating(for currentMouse: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
        let currentPosition: CGPoint = currentMouse.position
        let angle: CGFloat = atan2(currentPosition.y - targetTouch.y, currentPosition.x - targetTouch.x)
        let action: SKAction = SKAction.move(to: targetTouch, duration: 0.5)
        currentMouse.run(action)
        
        let xVelocity: CGFloat = cos(angle) * speed
        let yVelocity: CGFloat = sin(angle) * speed
        let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
        currentMouse.physicsBody?.velocity = velocity
        
        
        let distanceBetweenMice: CGFloat = 30
        if let miceCount = mice?.count, miceCount > 1 {
            for i in (1..<miceCount).reversed() {
                let mouse: SKSpriteNode = mice![i]
                let previousMouse: SKSpriteNode = mice![i - 1]
                let newPosition: CGPoint = CGPoint(x: previousMouse.position.x - distanceBetweenMice, y: previousMouse.position.y)
                let moveAction: SKAction = SKAction.move(to: newPosition, duration: 0.5)
                mouse.run(moveAction)
                mouse.zPosition = previousMouse.zPosition + 1 // Ensure nodes are layered properly
            }
        }
    }


    fileprivate func updateCatsChasing() {
        guard let leadingMouse = leadingMouse else {
            return
        }
        let targetPosition: CGPoint = leadingMouse.position
        for cat: SKSpriteNode in cats { // this part to make all cats move to the mouse
            updateMovement(for: cat, to: targetPosition, speed: catSpeed)
        }
    }

    fileprivate func updateMovement(for currentNode: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
         let currentPosition: CGPoint = currentNode.position
         let angle: CGFloat = CGFloat.pi + atan2(currentPosition.y - targetTouch.y, currentPosition.x - targetTouch.x)
         let rotation: SKAction = SKAction.rotate(toAngle: angle + (CGFloat.pi * 0.7), duration: 3, shortestUnitArc: true)
         currentNode.run(rotation)
        
         let xVelocity: CGFloat = cos(angle) * speed * 0.3
         let yVelocity: CGFloat = sin(angle) * speed * 0.3
         let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
         currentNode.physicsBody?.velocity = velocity
    }
    

    // handle collision events
    public func collisionHandling(_ contact: SKPhysicsContact)
    {
        var bodyA: SKPhysicsBody
        var bodyB: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        } else {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        // to check is contact or not
        if bodyA.categoryBitMask == leadingMouse?.physicsBody?.categoryBitMask && bodyB.categoryBitMask == exitHole?.physicsBody?.categoryBitMask {
            upLevel(true)
        } else if bodyA.categoryBitMask == leadingMouse?.physicsBody?.categoryBitMask && bodyB.categoryBitMask == cats[0].physicsBody?.categoryBitMask {
            upLevel(false)
        }
    }

    // handle the end of the game
    fileprivate func upLevel(_ win: Bool) {
        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
        let blankScene = SKScene(size: view!.bounds.size)

        view?.presentScene(blankScene, transition: transition)
    }
}
