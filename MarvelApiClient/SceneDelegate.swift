//
//  SceneDelegate.swift
//
import UIKit
@available(iOS 13.0, *)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  let restDep = RestDependencies()
  var dependencies: AppDependencies { AppDependencies(restDependencies: restDep)} 
  private var appCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    print("FB:SceneDelegate:")
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      appCoordinator = AppCoordinator(presenter: window, dependencies: dependencies)
      appCoordinator?.start()
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    print("FB:SceneDelegate url: \(url)")
    //DeeplinkParser.shared.handleDeeplink(url: url)
    let deeplink =  DeeplinkParser.shared.parseDeepLink(url)
    //let deeplink = DeepLinkOption.build(with: "landing", params: nil)
    appCoordinator?.start(with: deeplink)
  }
}
