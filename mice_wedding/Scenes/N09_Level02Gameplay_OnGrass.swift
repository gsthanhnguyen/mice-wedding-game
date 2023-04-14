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
        let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 10, duration: 0.5), SKAction.moveBy(x: 0, y: -10, duration: 0.5)])
        let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
        // animation moving left and right
        let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
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

        // leaf = childNode(withName: "leaf") as? SKSpriteNode
        // leaf?.run(repeatFlash)
        // leaf?.zPosition = 1
        // leaf?.physicsBody = SKPhysicsBody(rectangleOf: leaf!.size)
        // leaf?.physicsBody?.categoryBitMask = 8 // 8: leaf
        // leaf?.physicsBody?.collisionBitMask = 1 // 1: mouse
        // leaf?.physicsBody?.contactTestBitMask = 1 // 1: mouse
        // leaf?.physicsBody?.affectedByGravity = false

        // set up the animation for nodes and add them to the array list
        for child in self.children {
            if child.name == "cat" {
                if let child = child as? SKSpriteNode {
                    print("set cat")
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
                print("set mouse")
                if let child = child as? SKSpriteNode {
                    child.run(moveLeftRightContinuously)
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
                print("set leaf")
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
        print("done setting up mice and cats")
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
            updatePosition(for: cat, to: targetPosition, speed: catSpeed)
        }
    }
    
    fileprivate func updatePosition(for sprite: SKSpriteNode, to target: CGPoint, speed: CGFloat) {
        let currentPosition = sprite.position
        let angle = CGFloat.pi + atan2(currentPosition.y - target.y, currentPosition.x - target.x)
        // let rotateAction = SKAction.rotate(toAngle: angle + (CGFloat.pi*0.5), duration: 0)
        // sprite.run(rotateAction)
        
        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)
        
        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
        sprite.physicsBody?.velocity = newVelocity
        print("moving cat")
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
        print("moving mouse")

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
            upLevel(false)
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
    }

    // handle the end of the game
    fileprivate func upLevel(_ didWin: Bool) {
        let transition: SKTransition = SKTransition.fade(withDuration: 1.0)
        let resultScene = LevelDecision(didWin: didWin, jumpToLevel: 2, size: size)
        view?.presentScene(resultScene, transition: transition)
    }
}

// import SpriteKit

// public class N09_Level02Gameplay_OnGrass: SKScene, SKPhysicsContactDelegate {
//     // start scene
//     // set speed for Mice and Cat
//     let miceSpeed: CGFloat = 100
//     let catSpeed: CGFloat = 120
//     let leafDuration: CGFloat = 6.0

//     // declare objects
//     var mice: [SKSpriteNode]? = [] // using array list to manage multiple mouse
//     var leadingMouse: SKSpriteNode?
//     var cats: [SKSpriteNode] = [] // using array list to manage multiple cats
//     var exitHole: SKSpriteNode?

//     var leaf: SKSpriteNode?
//     var isCovered: Bool = false
//     var leafCoveredCount: Int = 0

//     var lastTouchLocation: CGPoint? = nil

//     // set up the physics category
//     struct PhysicsCategory { // declare all kind of node in the scene in this struct
//     static let cat: UInt32 = 0x1 << 0 // 1
//     static let mouse: UInt32 = 0x1 << 1 // 2
//     static let exitHole: UInt32 = 0x1 << 2 // 4
//     static let leaf: UInt32 = 0x1 << 3 // 8
//     }

//     // set animation for Nodes
//     override public func didMove(to view: SKView) {
//         // set physics
//         physicsWorld.contactDelegate = self

//         // set up the exit hole
//         exitHole = SKSpriteNode(imageNamed: "exitHole")

//         // animation moving up and down
//         let moveUpDown: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 10, duration: 0.5), SKAction.moveBy(x: 0, y: -10, duration: 0.5)])
//         let moveUpDownContinuously: SKAction = SKAction.repeatForever(moveUpDown)
//         // animation moving left and right
//         let moveLeftRight: SKAction = SKAction.sequence([SKAction.moveBy(x: 20, y: 0, duration: 0.5), SKAction.moveBy(x: -20, y: 0, duration: 0.5)])
//         let moveLeftRightContinuously: SKAction = SKAction.repeatForever(moveLeftRight)
        
//         let flashDuration = 4.0 // The duration of each flash
//         let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: flashDuration / 2)
//         let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: flashDuration / 2)
//         let flash = SKAction.sequence([fadeIn, fadeOut])
//         let repeatFlash = SKAction.repeatForever(flash)


//         // set up the animation for nodes and add them to the array list
//         for child: SKNode in self.children {
//             if let nodeName = child.name, nodeName.hasPrefix("mouse_") { // declare the name of the node in the scene
//                 child.run(moveUpDownContinuously)
//                 let mouseNode = child as! SKSpriteNode
//                 mouseNode.physicsBody = SKPhysicsBody(rectangleOf: mouseNode.size)
//                 mouseNode.physicsBody?.categoryBitMask = PhysicsCategory.mouse // set the category of the node
//                 mouseNode.physicsBody?.collisionBitMask = PhysicsCategory.cat // set the collision of the node
//                 mouseNode.physicsBody?.contactTestBitMask = PhysicsCategory.cat // set the contact of the node
//                 mouseNode.physicsBody?.affectedByGravity = false // set the gravity of the node
//                 mouseNode.physicsBody?.allowsRotation = false // set the rotation of the node

//                 mice?.append(mouseNode)
//             } else if child.name == "cat" { // declare the name of the node in the scene
//                 child.run(moveLeftRightContinuously)
//                 let catNode = child as! SKSpriteNode
//                 catNode.physicsBody = SKPhysicsBody(rectangleOf: catNode.size)
//                 catNode.physicsBody?.categoryBitMask = PhysicsCategory.cat
//                 catNode.physicsBody?.collisionBitMask = PhysicsCategory.mouse
//                 catNode.physicsBody?.contactTestBitMask = PhysicsCategory.mouse
//                 catNode.physicsBody?.affectedByGravity = false
//                 catNode.physicsBody?.allowsRotation = false

//                 cats.append(catNode)
//             } else if child.name == "exitHole" {
//                 child.run(repeatFlash) // set the animation of the node
//                 let exitHoleNode: SKSpriteNode = child as! SKSpriteNode
//                 exitHoleNode.physicsBody = SKPhysicsBody(rectangleOf: exitHoleNode.size)
//                 exitHoleNode.physicsBody?.categoryBitMask = PhysicsCategory.exitHole // set the category of the node
//                 exitHoleNode.physicsBody?.collisionBitMask = PhysicsCategory.mouse // set the collision of the node
//                 exitHoleNode.physicsBody?.contactTestBitMask = PhysicsCategory.mouse // set the contact of the node
//                 exitHoleNode.physicsBody?.affectedByGravity = false // set the gravity of the node
//             } else if child.name == "leaf" {
//                 child.run(repeatFlash) // set the animation of the node
//                 let leafNode: SKSpriteNode = child as! SKSpriteNode
//                 leafNode.physicsBody = SKPhysicsBody(rectangleOf: leafNode.size)
//                 leafNode.physicsBody?.categoryBitMask = PhysicsCategory.leaf // set the category of the node
//                 leafNode.physicsBody?.collisionBitMask = PhysicsCategory.mouse // set the collision of the node
//                 leafNode.physicsBody?.contactTestBitMask = PhysicsCategory.mouse // set the contact of the node
//                 leafNode.physicsBody?.affectedByGravity = false // set the gravity of the node
//             }
            
//         }
//     }

//     // handle touche events and get the location of the touch
//     override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//         handleTouches(touches)
//     }
//     override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//         handleTouches(touches)
//     }
//     override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//         handleTouches(touches)
//     }
//     // get the location of the touch
//     fileprivate func handleTouches(_ touches: Set<UITouch>) {
//         lastTouchLocation = touches.first?.location(in: self)
//     }

//     // updating the position and other properties of nodes that are affected by physics
//     override public func didSimulatePhysics() {
//         updateMice()
//         updateCatsChasing()
//     }

//     fileprivate func updateMice() {
//         guard let lastTouchLocation: CGPoint = lastTouchLocation, let mice = mice, let leadingMouse = mice.first
//         else {
//             return
//         }
//         let currentPosition: CGPoint = leadingMouse.position
//         let xDistance = abs(currentPosition.x - lastTouchLocation.x)
//         let yDistance = abs(currentPosition.y - lastTouchLocation.y)
//         if xDistance > leadingMouse.frame.width/2 || yDistance > leadingMouse.frame.height/2 {
//             print("updateMice: update mouse movement")
//             mouseMovementUpdating(for: leadingMouse, to: lastTouchLocation, speed: miceSpeed)
//         } else {
//             leadingMouse.physicsBody?.isResting = true
//         }
//     }
    
//     // update the position of the leading mouse
//     fileprivate func mouseMovementUpdating(for currentMouse: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
//         let currentPosition: CGPoint = currentMouse.position
//         let angle: CGFloat = atan2(currentPosition.y - targetTouch.y, currentPosition.x - targetTouch.x)
//         let action: SKAction = SKAction.move(to: targetTouch, duration: 1)
//         currentMouse.run(action)
//         leadingMouse = currentMouse // update new position of the leading mouse to help cats chase after it
        
//         let xVelocity: CGFloat = cos(angle) * speed * 0.4
//         let yVelocity: CGFloat = sin(angle) * speed * 0.4
//         let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
//         currentMouse.physicsBody?.velocity = velocity
        
//         // update mice moving after the leading mouse
//         let distanceBetweenMice: CGFloat = 50
//         if let miceCount = mice?.count, miceCount > 1 {
//             for i in (1..<miceCount).reversed() {
//                 let mouse: SKSpriteNode = mice![i]
//                 let previousMouse: SKSpriteNode = mice![i - 1]
//                 let newPosition: CGPoint = CGPoint(x: previousMouse.position.x - distanceBetweenMice, y: previousMouse.position.y)
//                 let moveAction: SKAction = SKAction.move(to: newPosition, duration: 0.2)
//                 mouse.run(moveAction)
//                 mouse.zPosition = previousMouse.zPosition + 1 // Ensure nodes are layered properly
//             }
//         }
//     }

//     // update the position of the cat
//     fileprivate func updateCatsChasing() {
//         guard let leadingMouse = leadingMouse else {
//             return
//         }
//         let targetPosition: CGPoint = leadingMouse.position
//         for cat: SKSpriteNode in cats { // this part to make all cats move to the mouse
//             print("updateCatChasing: cat movement updating")
//             catMovementUpdating(for: cat, to: targetPosition, speed: catSpeed)
//         }
//     }

//     // update the position of the cat
//     fileprivate func catMovementUpdating(for currentNode: SKSpriteNode, to targetTouch: CGPoint, speed: CGFloat) {
//         let currentPosition: CGPoint = currentNode.position
//         let angle: CGFloat = CGFloat.pi + atan2(currentPosition.y - targetTouch.y, currentPosition.x - targetTouch.x)
//         let rotation: SKAction = SKAction.rotate(toAngle: angle + (CGFloat.pi * 0.7), duration: 1, shortestUnitArc: true)
//         currentNode.run(rotation)
        
//         let xVelocity: CGFloat = cos(angle) * speed * 0.5
//         let yVelocity: CGFloat = sin(angle) * speed * 0.5
//         let velocity: CGVector = CGVector(dx: xVelocity, dy: yVelocity)
//         currentNode.physicsBody?.velocity = velocity
//     }

//     // handle the contact between the cat and the mouse
//     public func didBegin(_ contact: SKPhysicsContact) {
//         var firstBody: SKPhysicsBody
//         var secondBody: SKPhysicsBody

//         if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//             firstBody = contact.bodyA
//             secondBody = contact.bodyB
//         } else {
//             firstBody = contact.bodyB
//             secondBody = contact.bodyA
//         }

//         if firstBody.categoryBitMask == PhysicsCategory.cat && secondBody.categoryBitMask == PhysicsCategory.mouse {
//             if !isCovered {
//                 upLevel(false)
//             }
//         } else if firstBody.categoryBitMask == PhysicsCategory.mouse && secondBody.categoryBitMask == PhysicsCategory.exitHole {
//             upLevel(true)
//         } else if firstBody.categoryBitMask == PhysicsCategory.mouse && secondBody.categoryBitMask == PhysicsCategory.leaf {
//             if let leafNode = secondBody.node as? SKSpriteNode {
//                 leafNode.removeFromParent()
//             }
//             self.isLeafCovered()
//         }
//     }

//     fileprivate func isLeafCovered() {
//         isCovered = true
//         leafCoveredCount += 1
        
//         let duration: CGFloat = 0.35
//         let count: Int = 20

//         for mouse in mice! {
//             mouse.run(SKAction.repeat(
//             SKAction.sequence([
//                 SKAction.setTexture(SKTexture(imageNamed: "leaf")),
//                 SKAction.moveBy(x: 0, y: 0, duration: duration),
//                 SKAction.setTexture(SKTexture(imageNamed: "mouse")),
//                 SKAction.moveBy(x: 0, y: 0, duration: duration),
//                 ]
//             ), count: count
//             ))
//             mouse.run(SKAction.setTexture(SKTexture(imageNamed: "mouse"))) // reset texture after animation
//         }
        
//         DispatchQueue.main.asyncAfter(deadline: .now() + self.leafDuration + duration * CGFloat(count)) {
//             if self.leafCoveredCount <= 1 {
//                 self.isCovered = false
//             }
//             self.leafCoveredCount -= 1
//         }
//     }

//     // handle the end of the game
//     fileprivate func upLevel(_ didWin: Bool) {
//         let transition: SKTransition = SKTransition.fade(withDuration: 1.0)
//         let resultScene = LevelDecision(didWin: didWin, jumpToLevel: 2, size: size)
//         view?.presentScene(resultScene, transition: transition)
//     }
// }
