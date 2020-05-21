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
	
	@IBOutlet weak var downloadButton: UIButton!
	
	@IBAction func downloadButtonClicked(_ sender: UIButton) {
		if let highlight = highlight {
			onDownloadButtonClicked?(highlight)			
		}
	}
	
	var highlight: Highlight? {
		didSet {
			guard let highlight = highlight else {
				return
			}
			if let imageUrlString = highlight.imageUrlString {
				highlightTypeImageView.image = #imageLiteral(resourceName: "image")
				if let imageUrl = URL(string: imageUrlString) {
					Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)),into: previewImageView)
				}
			} else if let videoUrlString = highlight.videoUrlString {
				highlightTypeImageView.image = #imageLiteral(resourceName: "video")
				let image = UIImage()
				if let videoUrl = URL(string: videoUrlString) {
					image.getThumbnailImageFromVideoUrl(url: videoUrl) { (image) in
						UIView.transition(with: self.previewImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
							self.previewImageView.image = image
						})
					}
				}
			}
		}
	}
	
	var onDownloadButtonClicked: ((_ highlight: Highlight) -> ())?
	
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		Decorator.decorate(self)
	}
}


extension HighlightCollectionViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: HighlightCollectionViewCell) {
			cell.round(value: 4)
			cell.highlightTypeImageView.superview!.round()
			cell.downloadButton.round()
			cell.applyBorder(borderColor: .black, borderWidth: 0.5)
		}
	}
}
