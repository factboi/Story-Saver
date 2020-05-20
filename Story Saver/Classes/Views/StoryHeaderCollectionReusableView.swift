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

	@IBOutlet weak var expandButton: UIButton!
	@IBOutlet weak var highlightsCollectionView: UICollectionView!
	@IBOutlet weak var followingCountLabel: UILabel!
	@IBOutlet weak var followersCountLabel: UILabel!
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet private weak var imageView: UIImageView! {
		didSet {
			imageView.isUserInteractionEnabled = true
			imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageTapped(_:))))
		}
	}
	
	var onExpandButtonClicked: (() -> Void)?
	
	public func set(_ userInfo: UserDetailInfo) {
		if let imageUrl = URL(string: userInfo.profilePicUrlHd) {
			Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: imageView)
		}
		fullNameLabel.text = userInfo.fullName
		followersCountLabel.text = "\(userInfo.followersCount.count)"
		followingCountLabel.text = "\(userInfo.followingCount.count)"
		subviews.forEach { (view) in
			UIView.animate(withDuration: 0.3) {
				view.alpha = 1
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		subviews.forEach({$0.alpha = 0})
	}
	
	@IBAction func expandButtonClicked(_ sender: UIButton) {
		onExpandButtonClicked?()
	}
	
	@objc private func onImageTapped(_ sender: UITapGestureRecognizer) {
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
