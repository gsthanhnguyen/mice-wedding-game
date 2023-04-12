//
//  GameViewController.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-07.
//

import UIKit
import SpriteKit
import GameplayKit
import PlaygroundSupport

//class GameViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = N01_Intro(fileNamed: "Sources/N01_Intro") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 720, height: 540))
if let scene = N01_Intro(fileNamed: "N01_Intro") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

