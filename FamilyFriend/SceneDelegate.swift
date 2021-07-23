//
//  SceneDelegate.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 07/07/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		
		showRootView(window: window)
	}
	
	func showRootView(window: UIWindow?) {
		guard let window = window else { return }
		
		// TODO: Move this to factory
		let rootConnector = MainConnector()
		let rootViewController = rootConnector.connect()
				
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()
	}
}

