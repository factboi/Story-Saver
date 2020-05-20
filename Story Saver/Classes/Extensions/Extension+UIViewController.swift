//
//  Extension+UIViewController.swift
//  Story Saver
//
//  Created by factboi on 20.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import AVKit

extension UIViewController {
	func playVideoByUrl(_ videoUrlString: String) {
		if let videoUrl = URL(string: videoUrlString) {
			let player = AVPlayer(url: videoUrl)
			let vc = AVPlayerViewController()
			vc.player = player
			present(vc, animated: true) {
				vc.player?.play()
			}
		}
	}
}
