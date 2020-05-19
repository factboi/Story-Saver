//
//  StoryCollectionViewCell.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke

class StoryCollectionViewCell: UICollectionViewCell, NibLoadable {

	@IBOutlet weak var previewImageView: UIImageView!
	@IBOutlet weak var storyTypeImageView: UIImageView! {
		didSet {
			storyTypeImageView.alpha = 0
		}
	}
	
	override var isHighlighted: Bool {
		didSet {
			var transform: CGAffineTransform = .identity
			
			transform = isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
			
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
					self.transform = transform
			}, completion: nil)
		}
	}

	public func set(_ story: Story) {
		if let url = URL(string: story.preview) {
			Nuke.loadImage(with: url, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)),into: previewImageView, completion: .some({ (_) in
				self.storyTypeImageView.alpha = 1
			}))
		}
		storyTypeImageView.image = story.video.isEmpty ? #imageLiteral(resourceName: "image") : #imageLiteral(resourceName: "video")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		Decorator.decorate(self)
	}
}

extension StoryCollectionViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: StoryCollectionViewCell) {
			cell.round(value: 4)
			cell.storyTypeImageView.superview!.round()
		}
	}
}
