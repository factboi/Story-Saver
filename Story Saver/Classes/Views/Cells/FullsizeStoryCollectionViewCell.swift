//
//  FullsizeStoryCollectionViewCell.swift
//  Story Saver
//
//  Created by factboi on 19.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke

class FullsizeStoryCollectionViewCell: UICollectionViewCell, NibLoadable {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	
	
    override func awakeFromNib() {
			super.awakeFromNib()
			scrollView.delegate = self
			scrollView.minimumZoomScale = 1
			scrollView.maximumZoomScale = 3
			scrollView.zoomScale = 1
    }
	
	func set(_ story: Story) {
		if let imageUrl = URL(string: story.preview) {
			Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)),into: imageView)
		}
	}
}

extension FullsizeStoryCollectionViewCell: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
