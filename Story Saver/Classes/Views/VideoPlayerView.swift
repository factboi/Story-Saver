//
//  VideoPlayerView.swift
//  Story Saver
//
//  Created by factboi on 19.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
	
	var videoUrlString: String?

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		if let urlString = videoUrlString {
			if let url = URL(string: urlString) {
				let player = AVPlayer(url: url)
				let playerLayer = AVPlayerLayer(player: player)
				playerLayer.frame = bounds
				layer.addSublayer(playerLayer)
				player.play()
			}
		}
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
}
