//
//  grass.swift
//  mice-wedding
//
//  Created by Thanh Nguyen on 2023-04-06.
//

import SpriteKit
import UIKit
import CoreGraphics

public class underGroundScene: SKScene, SKPhysicsContactDelegate {
    // set speed for Mice and Cat
    let miceSpeed: CGFloat = 100
    let catSpeed: CGFloat = 120

    // declare objects
    var mice: [SKSpriteNode]? = [] // using array list to manage multiple mouse
    var leadingMouse: SKSpriteNode?
    var cats: [SKSpriteNode]? = [] // using array list to manage multiple cats
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

        // set up the animation for nodes and add them to the array list
        for child: SKNode in self.children {
            if child.name == "mouse" { // declare the name of the node in the scene
                child.run(moveUpDownContinuously)
                mice?.append(child as! SKSpriteNode)
            } else if child.name == "cat" { // declare the name of the node in the scene
                child.run(moveLeftRightContinuously)
                cats?.append(child as! SKSpriteNode)
            } 
        }

        // make mouses move together with the first mouse
        let firstMouse: SKSpriteNode = mice![0]
        for i: Int in 1..<mice!.count {
            let mouse: SKSpriteNode = mice![i]
            if i == 1 {
                leadingMouse = mouse
            }
            let offset: CGFloat = CGFloat(i) * 10 // offset the position of the mouse
            mouse.position = CGPoint(x: firstMouse.position.x + offset, y: firstMouse.position.y)
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

    // TODO: check again this function because nodes have to move together
    fileprivate func updateMice() {
        guard let touch: CGPoint = lastTouchLocation else {
            return
        }
        let currentPosition: CGPoint = leadingMouse!.position
        let xDistance = abs(touch.x - currentPosition.x)
        let yDistance = abs(touch.y - currentPosition.y)
        if xDistance > leadingMouse!.frame.width/2 || yDistance > leadingMouse!.frame.height/2 {
            updateMovement(for: leadingMouse!, to: touch, speed: miceSpeed)
        } else {
            leadingMouse!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }

    fileprivate func updateMovement(for currentNode: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
        let currentPosition: CGPoint = currentNode.position
        let angle: CGFloat = CGFloat.pi + atan2(targetTouch.y - currentPosition.y, targetTouch.x - currentPosition.x)
        let rotation: SKAction = SKAction.rotate(toAngle: angle, duration: 0.1, shortestUnitArc: true)
        currentNode.run(rotation) // TODO: check again await, not sure
        
        let xVelocity: CGFloat = cos(angle) * speed
        let yVelocity: CGFloat = sin(angle) * speed
        let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
        currentNode.physicsBody?.velocity = velocity
    }

    fileprivate func updateCatsChasing() {
        guard let _: SKSpriteNode = leadingMouse else {
            return
        }
        let targetPosition: CGPoint = leadingMouse!.position
        for cat: SKSpriteNode in cats! { // this part to make all cats move to the mouse
            updateMovement(for: cat, to: targetPosition, speed: catSpeed)
        }
    }

    // handle collision events
    public func handleCollision(_ contact: SKPhysicsContact)
    {
        var bodyA: SKPhysicsBody
        var bodyB: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            let bodyA: SKPhysicsBody = contact.bodyA
            let bodyB: SKPhysicsBody = contact.bodyB
        } else {
            let bodyA: SKPhysicsBody = contact.bodyB
            let bodyB: SKPhysicsBody = contact.bodyA
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
        if win {
            view?.presentScene()
        }
    }
}