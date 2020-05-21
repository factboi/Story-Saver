//
//  HighlightCollectionViewCell.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke

class HighlightCollectionViewCell: UICollectionViewCell, NibLoadable {
	@IBOutlet weak var previewImageView: UIImageView!
	@IBOutlet weak var highlightTypeImageView: UIImageView!
	
	func set(highlight: Highlight) {
		if let imageUrlString = highlight.imageUrlString {
			highlightTypeImageView.image = #imageLiteral(resourceName: "image")
			if let imageUrl = URL(string: imageUrlString) {
				Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)),into: previewImageView)
			}
		} else if let videoUrlString = highlight.videoUrlString {
			previewImageView.backgroundColor = .black
			highlightTypeImageView.image = #imageLiteral(resourceName: "video")
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		Decorator.decorate(self)
	}
}


extension HighlightCollectionViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: HighlightCollectionViewCell) {
			cell.round(value: 4)
			cell.highlightTypeImageView.superview!.round()
			cell.applyBorder(borderColor: .black, borderWidth: 0.5)
		}
	}
}
