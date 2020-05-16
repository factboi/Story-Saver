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
	
	func root(_ window: UIWindow, _ scene: UIScene) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window.frame = windowScene.coordinateSpace.bounds
		window.makeKeyAndVisible()
		window.windowScene = windowScene
		window.rootViewController = UINavigationController(rootViewController: rootViewController)
	}
}
