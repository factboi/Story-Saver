//
//  Router.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class Router {
	static let shared = Router()
	private init() {}
	
	private let rootViewController = ViewController()
	
	@available(iOS 13.0, *)
	func root(_ window: UIWindow, _ scene: UIScene) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window.frame = windowScene.coordinateSpace.bounds
		window.makeKeyAndVisible()
		window.windowScene = windowScene
		window.rootViewController = UINavigationController(rootViewController: rootViewController)
	}
	
	func root(_ window: inout UIWindow?) {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.backgroundColor = .white
		window?.rootViewController = UINavigationController(rootViewController: rootViewController)
	}
}
