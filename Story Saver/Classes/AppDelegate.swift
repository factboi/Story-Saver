//
//  AppDelegate.swift
//  Story Saver
//
//  Created by factboi on 14.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Photos
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		try? AVAudioSession.sharedInstance().setCategory(.playback)
		PHPhotoLibrary.requestAuthorization { (_) in }
		Router.shared.root(&window)
		return true
	}
}

