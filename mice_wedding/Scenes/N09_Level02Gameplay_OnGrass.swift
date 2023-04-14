//  mice-wedding
//
//  Created by Thanh Nguyen on 2023-04-06.
//

import SpriteKit

public class N09_Level02Gameplay_OnGrass: SKScene, SKPhysicsContactDelegate {
    // start scene
    // set speed for Mice and Cat
    let mouseSpeed: CGFloat = 200.0
    let catSpeed: CGFloat = 20.0
    let leafDuration: CGFloat = 6.0

    // declare objects
    var mouse: SKSpriteNode?
    var mice: [SKSpriteNode] = [] // using array list to manage multiple mouse
    // var leadingMouse: SKSpriteNode?
    var cats: [SKSpriteNode] = [] // using array list to manage multiple cats
    var exitHole: SKSpriteNode?

    // var leaf: SKSpriteNode?
    var leaves: [SKSpriteNode] = [] // using array list to manage multiple leaves
    var isCovered: Bool = false
    var leafCoveredCount: Int = 0

    var lastTouch: CGPoint? = nil
    var N09_background: SKSpriteNode?

    // set animation for Nodes
    override public func didMove(to view: SKView) {
        // set physics
        physicsWorld.contactDelegate = self
        N09_background = childNode(withName: "N09_background") as? SKSpriteNode
        N09_background?.zPosition = -1

        // animation moving up and down
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 25, duration: 0.5), SKAction.moveBy(x: 0, y: -25, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 30, y: 0, duration: 0.5), SKAction.moveBy(x: 0, y: 0, duration: 0.5)])
        let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)
        // animation fading in and out
        let flashDuration = 4.0 // The duration of each flash
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: flashDuration / 2)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: flashDuration / 2)
        let flash = SKAction.sequence([fadeIn, fadeOut])
        let repeatFlash = SKAction.repeatForever(flash)

        // set up the exit hole
        exitHole = childNode(withName: "exitHole") as? SKSpriteNode
        exitHole?.run(repeatFlash)
        exitHole?.zPosition = 1
        exitHole?.physicsBody = SKPhysicsBody(rectangleOf: exitHole!.size)
        exitHole?.physicsBody?.categoryBitMask = 2 // 2: exitHole
        exitHole?.physicsBody?.collisionBitMask = 1 // 1: mouse
        exitHole?.physicsBody?.contactTestBitMask = 1 // 1: mouse
        exitHole?.physicsBody?.affectedByGravity = false
        exitHole?.physicsBody?.allowsRotation = false

        // set up the animation for nodes and add them to the array list
        for child in self.children {
            if child.name == "cat" {
                if let child = child as? SKSpriteNode {
                    let texture1 = SKTexture(imageNamed: "mouse_1")
                    let texture2 = SKTexture(imageNamed: "cat")
                    let runningFrames = [texture1, texture2]
                    let runningAnimation = SKAction.animate(with: runningFrames, timePerFrame: 0.1)
                    let catRunningAnimation = SKAction.repeatForever(runningAnimation)
                    child.run(catRunningAnimation)

                    child.run(moveLeftRightContinuously)
                    child.run(moveUpDownContinuously)
                    child.zPosition = 1
                    child.physicsBody = SKPhysicsBody(rectangleOf: child.size)
                    child.physicsBody?.categoryBitMask = 4 // 4: cat
                    child.physicsBody?.collisionBitMask = 1 // 1: mouse
                    child.physicsBody?.contactTestBitMask = 1 // 1: mouse
                    child.physicsBody?.affectedByGravity = false
                    child.physicsBody?.allowsRotation = false
                    cats.append(child)
                }
            } else if let nodeName = child.name, nodeName.hasPrefix("mouse_") { // declare the name of the node in the scene
                if let child = child as? SKSpriteNode {
                    child.run(moveUpDownContinuously)
                    child.zPosition = 1
                    child.physicsBody = SKPhysicsBody(rectangleOf: child.size)
                    child.physicsBody?.categoryBitMask = 1 // 1: mouse
                    child.physicsBody?.collisionBitMask = 2 | 4 | 8 // 2: exitHole, 4: cat
                    child.physicsBody?.contactTestBitMask = 2 | 4 | 8 // 2: exitHole, 4: cat
                    child.physicsBody?.affectedByGravity = false
                    child.physicsBody?.allowsRotation = false
                    mice.append(child)
                }
            } else if child.name == "leaf" {
                if let child = child as? SKSpriteNode {
                    child.run(repeatFlash) // set the animation of the node
                    child.zPosition = 1
                    child.physicsBody = SKPhysicsBody(rectangleOf: child.size)
                    child.physicsBody?.categoryBitMask = 8 // 8: leaf
                    child.physicsBody?.collisionBitMask = 1 // 1: mouse
                    child.physicsBody?.contactTestBitMask = 1 // 1: mouse
                    child.physicsBody?.affectedByGravity = false // set the gravity of the node
                    leaves.append(child)                    
                }
            }
        }
        mouse = mice.first
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
        lastTouch = touches.first?.location(in: self)
    }

    // updating the position and other properties of nodes that are affected by physics
    override public func didSimulatePhysics() {
        if mouse != nil {
            updateMice()
            updateCats()
        }
    }

    fileprivate func shouldMove(currentPosition: CGPoint,
                                touchPosition: CGPoint) -> Bool {
        guard let mouse = mouse else { return false }
        return abs(currentPosition.x - touchPosition.x) > mouse.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > mouse.frame.height / 2
    }
    
    fileprivate func updateMice() {
        guard let mouse = mouse,
            let touch = lastTouch
            else { return }
        let currentPosition = mouse.position
        if shouldMove(currentPosition: currentPosition,
                      touchPosition: touch) {
            updateMicePosition(for: mouse, to: touch, speed: mouseSpeed)
        } else {
            mouse.physicsBody?.isResting = true
        }
    }
    
    func updateCats() {
        guard let mouse = mouse else { return }
        let targetPosition = mouse.position
        
        for cat in cats {
            updateCatsPosition(for: cat, to: targetPosition, speed: catSpeed)
        }
    }
    
    fileprivate func updateCatsPosition(for sprite: SKSpriteNode, to target: CGPoint, speed: CGFloat) {
        let currentPosition = sprite.position
        let angle = CGFloat.pi + atan2(currentPosition.y - target.y, currentPosition.x - target.x)
        let rotateAction = SKAction.rotate(toAngle: angle + (CGFloat.pi), duration: 0)
        // let rotateAction = SKAction.rotate(toAngle: angle, duration: 0)
        sprite.run(rotateAction)
        
        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)
        
        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
        sprite.physicsBody?.velocity = newVelocity
    }

    fileprivate func updateMicePosition(for sprite: SKSpriteNode, to target: CGPoint, speed: CGFloat) {
        
        let currentPosition = sprite.position
        let angle = CGFloat.pi + atan2(currentPosition.y - target.y, currentPosition.x - target.x)
        // let rotateAction = SKAction.rotate(toAngle: angle + (CGFloat.pi*0.5), duration: 0)
        // sprite.run(rotateAction)
        
        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)
        
        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
        sprite.physicsBody?.velocity = newVelocity

        //update mice moving after the leading mouse
        let distanceBetweenMice: CGFloat = 70
        if mice.count > 1 {
            for i in (1..<mice.count).reversed() {
                let mouse: SKSpriteNode = mice[i]
                let previousMouse: SKSpriteNode = mice[i - 1]
                let newPosition: CGPoint = CGPoint(x: previousMouse.position.x - distanceBetweenMice, y: previousMouse.position.y)
                let moveAction: SKAction = SKAction.move(to: newPosition, duration: 0.2)
                mouse.run(moveAction)
                mouse.zPosition = previousMouse.zPosition + 1 // Ensure nodes are layered properly
            }
        }
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

        // Check contact
        if firstBody.categoryBitMask == mouse?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == cats[0].physicsBody?.categoryBitMask {
            print("mouse contact with cat")
            if !isCovered {
                upLevel(false)
            }
        } else if firstBody.categoryBitMask == mouse?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == exitHole?.physicsBody?.categoryBitMask {
            print("mouse contact with exitHole")
            upLevel(true)
        } else if firstBody.categoryBitMask == mouse?.physicsBody?.categoryBitMask &&
                    secondBody.categoryBitMask == leaves[0].physicsBody?.categoryBitMask {
            if let leafNode = secondBody.node as? SKSpriteNode {
                leafNode.removeFromParent()
            }
            print("mouse contact with leaf")
            self.isLeafCovered()
        }
    }

    fileprivate func isLeafCovered() {
        print("isLeafCovered called")
        isCovered = true
        leafCoveredCount += 1
        
        let duration: CGFloat = 0.35
        let count: Int = 20

        for mouse in mice {
            mouse.run(SKAction.repeat(
            SKAction.sequence([
                SKAction.setTexture(SKTexture(imageNamed: "leaf")),
                SKAction.moveBy(x: 0, y: 0, duration: duration),
                SKAction.setTexture(SKTexture(imageNamed: "mouse")),
                SKAction.moveBy(x: 0, y: 0, duration: duration),
                ]
            ), count: count
            ))
            mouse.run(SKAction.setTexture(SKTexture(imageNamed: "mouse"))) // reset texture after animation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.leafDuration + duration * CGFloat(count)) {
            if self.leafCoveredCount <= 1 {
                self.isCovered = false
            }
            self.leafCoveredCount -= 1
        }
        print(leafCoveredCount)
    }

    // handle the end of the game
    fileprivate func upLevel(_ didWin: Bool) {
        let transition: SKTransition = SKTransition.fade(withDuration: 1.0)
        let resultScene = LevelDecision(didWin: didWin, jumpToLevel: 2, size: size)
        view?.presentScene(resultScene, transition: transition)
    }
}