//
//  StoryHeaderCollectionReusableView.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke


class StoryHeaderCollectionReusableView: UICollectionReusableView, NibLoadable {

	@IBOutlet private weak var imageView: UIImageView! {
		didSet {
			imageView.alpha = 0
		}
	}
	
	var onExpandButtonClicked: (() -> Void)?
	
	public func set(_ userInfo: UserDetailInfo) {
		if let imageUrl = URL(string: userInfo.profilePicUrlHd) {
			Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: imageView, completion: .some({ (_) in
				self.imageView.alpha = 1
			}))
		}
	}
	
	@IBAction func expandButtonClicked(_ sender: UIButton) {
		onExpandButtonClicked?()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		Decorator.decorate(self)
	}
}

extension StoryHeaderCollectionReusableView {
	fileprivate final class Decorator {
		static func decorate(_ header: StoryHeaderCollectionReusableView) {
			header.imageView.round()
		}
	}
}
