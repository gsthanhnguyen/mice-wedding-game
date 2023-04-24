
import SwiftUI
import SpriteKit

struct SpriteView: UIViewRepresentable {
    typealias UIViewType = SKView
    
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.presentScene(scene)
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.presentScene(scene)
    }
    
//#if DEBUG
//    func previewDevice(_ device: PreviewDevice) -> some View {
//        let size: CGSize
//        switch device {
//        case .iPhoneSE:
//            size = CGSize(width: 640, height: 1136)
//        case .iPhone8:
//            size = CGSize(width: 750, height: 1334)
//        case .iPhone8Plus:
//            size = CGSize(width: 1080, height: 1920)
//        case .iPhone11Pro:
//            size = CGSize(width: 1125, height: 2436)
//        case .iPhone11ProMax:
//            size = CGSize(width: 1242, height: 2688)
//        case .iPadMini:
//            size = CGSize(width: 768, height: 1024)
//        case .iPadPro_11:
//            size = CGSize(width: 1668, height: 2388)
//        case .iPadPro_12_9:
//            size = CGSize(width: 2048, height: 2732)
//        default:
//            size = CGSize(width: 2732.0, height: 2048.0)
//        }
//        return SpriteView(scene: N01_Intro(fileNamed: "N01_Intro")!)
//            .frame(width: size.width, height: size.height)
//    }
//#endif
}

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SpriteView(scene: N01_Intro(fileNamed: "N01_Intro")!)
        }
    }
}
