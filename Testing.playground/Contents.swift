import SpriteKit
import GameplayKit
import PlaygroundSupport

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 720, height: 540))
if let scene = N01_Intro(fileNamed: "N01_Intro") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
