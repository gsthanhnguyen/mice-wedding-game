//
//  GameViewController.swift
//  mice_wedding_02
//
//  Created by Thanh Nguyen on 2023-04-07.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = N01_Intro(fileNamed: "N01_Intro") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


// code to initiate Swiftmp

//import SwiftUI
//import SpriteKit
//
//struct SpriteView: UIViewRepresentable {
//    typealias UIViewType = SKView
//    
//    let scene: SKScene
//    
//    func makeUIView(context: Context) -> SKView {
//        let view = SKView()
//        view.presentScene(scene)
//        return view
//    }
//    
//    func updateUIView(_ uiView: SKView, context: Context) {
//        uiView.presentScene(scene)
//    }
//    
//#if DEBUG
//    func sizeThatFits(_ size: CGSize) -> CGSize {
//        let deviceAspectRatio = CGFloat(2732.0 / 2048.0)
//        let screenRatio = size.width / size.height
//        let scaleFactor = screenRatio < deviceAspectRatio ? size.width / 2732.0 : size.height / 2048.0
//        return CGSize(width: scaleFactor * 2732.0, height: scaleFactor * 2048.0)
//    }
//    
//    func previewDevice(_ device: PreviewDevice) -> some View {
//        SpriteView(scene: N01_Intro(fileNamed: "N01_Intro")!)
//            .frame(width: 2732.0, height: 2048.0)
//    }
//#endif
//}
//
//@main
//struct MyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            SpriteView(scene: N01_Intro(fileNamed: "N01_Intro")!)
//        }
//    }
//}
