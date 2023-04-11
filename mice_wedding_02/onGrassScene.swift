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

    // set up the physics category
    struct PhysicsCategory {
    static let cat: UInt32 = 0x1 << 0 // 1
    static let mouse: UInt32 = 0x1 << 1 // 2
    static let exitHole: UInt32 = 0x1 << 2 // 4
    }

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
        
        let flashDuration = 4.0 // The duration of each flash
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: flashDuration / 2)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: flashDuration / 2)
        let flash = SKAction.sequence([fadeIn, fadeOut])
        let repeatFlash = SKAction.repeatForever(flash)


        // set up the animation for nodes and add them to the array list
        for child: SKNode in self.children {
            if let nodeName = child.name, nodeName.hasPrefix("mouse_") { // declare the name of the node in the scene
                child.run(moveUpDownContinuously)
                let mouseNode = child as! SKSpriteNode
                mouseNode.physicsBody = SKPhysicsBody(rectangleOf: mouseNode.size)
                mouseNode.physicsBody?.categoryBitMask = PhysicsCategory.mouse // set the category of the node
                mouseNode.physicsBody?.collisionBitMask = PhysicsCategory.cat // set the collision of the node
                mouseNode.physicsBody?.contactTestBitMask = PhysicsCategory.cat // set the contact of the node
                mouseNode.physicsBody?.affectedByGravity = false // set the gravity of the node
                mouseNode.physicsBody?.allowsRotation = false // set the rotation of the node

                mice?.append(mouseNode)
            } else if child.name == "cat" { // declare the name of the node in the scene
                child.run(moveLeftRightContinuously)
                let catNode = child as! SKSpriteNode
                catNode.physicsBody = SKPhysicsBody(rectangleOf: catNode.size)
                catNode.physicsBody?.categoryBitMask = PhysicsCategory.cat
                catNode.physicsBody?.collisionBitMask = PhysicsCategory.mouse
                catNode.physicsBody?.contactTestBitMask = PhysicsCategory.mouse
                catNode.physicsBody?.affectedByGravity = false
                catNode.physicsBody?.allowsRotation = false

                cats.append(catNode)
            } else if child.name == "exitHole" {
                child.run(repeatFlash)
                let exitHoleNode: SKSpriteNode = child as! SKSpriteNode
                exitHoleNode.physicsBody = SKPhysicsBody(rectangleOf: exitHoleNode.size)
                exitHoleNode.physicsBody?.categoryBitMask = PhysicsCategory.exitHole // set the category of the node
                exitHoleNode.physicsBody?.collisionBitMask = PhysicsCategory.mouse // set the collision of the node
                exitHoleNode.physicsBody?.contactTestBitMask = PhysicsCategory.mouse // set the contact of the node
                exitHoleNode.physicsBody?.affectedByGravity = false // set the gravity of the node
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
            print("updateMice: update mouse movement")
            mouseMovementUpdating(for: leadingMouse, to: lastTouchLocation, speed: miceSpeed)
        } else {
            leadingMouse.physicsBody?.isResting = true
        }
    }
    
    // update the position of the leading mouse
    fileprivate func mouseMovementUpdating(for currentMouse: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
        let currentPosition: CGPoint = currentMouse.position
        let angle: CGFloat = atan2(currentPosition.y - targetTouch.y, currentPosition.x - targetTouch.x)
        let action: SKAction = SKAction.move(to: targetTouch, duration: 1)
        currentMouse.run(action)
        leadingMouse = currentMouse // update new position of the leading mouse to help cats chase after it
        
        let xVelocity: CGFloat = cos(angle) * speed * 0.4
        let yVelocity: CGFloat = sin(angle) * speed * 0.4
        let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
        currentMouse.physicsBody?.velocity = velocity
        
        // update mice moving after the leading mouse
        let distanceBetweenMice: CGFloat = 50
        if let miceCount = mice?.count, miceCount > 1 {
            for i in (1..<miceCount).reversed() {
                let mouse: SKSpriteNode = mice![i]
                let previousMouse: SKSpriteNode = mice![i - 1]
                let newPosition: CGPoint = CGPoint(x: previousMouse.position.x - distanceBetweenMice, y: previousMouse.position.y)
                let moveAction: SKAction = SKAction.move(to: newPosition, duration: 0.2)
                mouse.run(moveAction)
                mouse.zPosition = previousMouse.zPosition + 1 // Ensure nodes are layered properly
            }
        }
    }

    // update the position of the cat
    fileprivate func updateCatsChasing() {
        guard let leadingMouse = leadingMouse else {
            return
        }
        let targetPosition: CGPoint = leadingMouse.position
        for cat: SKSpriteNode in cats { // this part to make all cats move to the mouse
            print("updateCatChasing: cat movement updating")
            catMovementUpdating(for: cat, to: targetPosition, speed: catSpeed)
        }
    }

    // update the position of the cat
    fileprivate func catMovementUpdating(for currentNode: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
        let currentPosition: CGPoint = currentNode.position
        let angle: CGFloat = CGFloat.pi + atan2(currentPosition.y - targetTouch.y, currentPosition.x - targetTouch.x)
        let rotation: SKAction = SKAction.rotate(toAngle: angle + (CGFloat.pi * 0.7), duration: 1, shortestUnitArc: true)
        currentNode.run(rotation)
        
        let xVelocity: CGFloat = cos(angle) * speed * 0.5
        let yVelocity: CGFloat = sin(angle) * speed * 0.5
        let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
        currentNode.physicsBody?.velocity = velocity
    }

    // handle the contact between the cat and the mouse
    public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if firstBody.categoryBitMask == PhysicsCategory.cat && secondBody.categoryBitMask == PhysicsCategory.mouse {
            upLevel(true)
        } else if firstBody.categoryBitMask == PhysicsCategory.mouse && secondBody.categoryBitMask == PhysicsCategory.exitHole {
            upLevel(true)
        }
    }

    // handle the end of the game
    fileprivate func upLevel(_ win: Bool) {
        let transition = SKTransition.fade(withDuration: 1.0)
        let blankScene = SKScene(size: view!.bounds.size)
        view?.presentScene(blankScene, transition: transition)
    }
}
