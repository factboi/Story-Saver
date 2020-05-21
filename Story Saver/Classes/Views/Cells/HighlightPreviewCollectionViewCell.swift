//
//  HighlightThumbnailCollectionViewCell.swift
//  Story Saver
//
//  Created by factboi on 20.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke


class HighlightPreviewCollectionViewCell: UICollectionViewCell, NibLoadable {
	
	@IBOutlet weak var label: UILabel! {
		didSet {
			label.adjustsFontSizeToFitWidth = true
		}
	}
	@IBOutlet weak var imageView: UIImageView!
	
	public func set(_ highlightJsonModel: HighlightJsonModel) {
		if let imageUrl = URL(string: highlightJsonModel.coverMedia.croppedImageVersion.url) {
			Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3)), into: imageView)
		}
		label.text = highlightJsonModel.title
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		Decorator.decorate(self)
	}
	
}

extension HighlightPreviewCollectionViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: HighlightPreviewCollectionViewCell) {
			cell.imageView.round()
		}
	}
}
