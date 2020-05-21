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

	@IBOutlet weak var downloadButton: UIButton!
	@IBOutlet weak var previewImageView: UIImageView!
	@IBOutlet weak var storyTypeImageView: UIImageView! {
		didSet {
			storyTypeImageView.alpha = 0
		}
	}
	
	var onDownloadClicked: ((_ story: Story) -> ())?
	
	var story: Story! {
		didSet {
			if let url = URL(string: story.preview) {
				Nuke.loadImage(with: url, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)),into: previewImageView, completion: .some({ (_) in
					self.storyTypeImageView.alpha = 1
				}))
			}
			storyTypeImageView.image = story.video.isEmpty ? #imageLiteral(resourceName: "image") : #imageLiteral(resourceName: "video")
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
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		Decorator.decorate(self)
	}
	
	@IBAction func downloadButtonClicked(_ sender: UIButton) {
		onDownloadClicked?(self.story)
	}
}

extension StoryCollectionViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: StoryCollectionViewCell) {
			cell.round(value: 4)
			cell.applyBorder(borderColor: .black, borderWidth: 0.5)
			cell.storyTypeImageView.superview!.round()
			cell.downloadButton.round()
		}
	}
}
