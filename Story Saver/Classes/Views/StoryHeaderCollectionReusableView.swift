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
	
	@IBOutlet weak var highlightsCollectionView: UICollectionView!
	
	private var user: User?
	private var highlightsHtmlModels: [HighlightHtmlModel]? {
		didSet {
			highlightsCollectionView.reloadSections(.init(integer: .zero))
		}
	}
	
	@IBOutlet weak var expandButton: UIButton!
	@IBOutlet weak var followingCountLabel: UILabel!
	@IBOutlet weak var followersCountLabel: UILabel!
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet private weak var imageView: UIImageView! {
		didSet {
			imageView.isUserInteractionEnabled = true
			imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageTapped(_:))))
		}
	}
	
	var onHighlightPreviewTapped: ((_ user: User, _ highlightJsonModel: HighlightHtmlModel) -> Void)?
	var onExpandButtonClicked: (() -> Void)?
	
	public func set(_ userInfo: UserDetailInfo, user: User, highlightsHtmlModels: [HighlightHtmlModel]) {
		self.user = user
		self.highlightsHtmlModels = highlightsHtmlModels
		if let imageUrl = URL(string: userInfo.profilePicUrlHd) {
			Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: imageView)
		}
		highlightsHtmlModels.isEmpty ? highlightsCollectionView.setEmptyViewWithMessage("No Highlights") : highlightsCollectionView.restore()
		fullNameLabel.text = userInfo.fullName
		followersCountLabel.text = "\(userInfo.followersCount.count)"
		followingCountLabel.text = "\(userInfo.followingCount.count)"
		subviews.forEach { (view) in
			UIView.animate(withDuration: 0.3) {
				view.alpha = 1
			}
		}
	}
	
	
	
	
	fileprivate func delegating() {
		highlightsCollectionView.delegate = self
		highlightsCollectionView.dataSource = self
	}
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		subviews.forEach({$0.alpha = 0})
		delegating()
		highlightsCollectionView.register(HighlightPreviewCollectionViewCell.nib, forCellWithReuseIdentifier: HighlightPreviewCollectionViewCell.name)
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
			header.expandButton.round()
		}
	}
}

extension StoryHeaderCollectionReusableView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let highlightHtmlModel = highlightsHtmlModels?[indexPath.item], let user = user {
			onHighlightPreviewTapped?(user, highlightHtmlModel)
		}
	}
}

extension StoryHeaderCollectionReusableView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return highlightsHtmlModels?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightPreviewCollectionViewCell.name, for: indexPath) as! HighlightPreviewCollectionViewCell
		if let highlightHtmlModel = highlightsHtmlModels?[indexPath.item] {
			cell.set(highlightHtmlModel)
		}
		return cell
	}
}

extension StoryHeaderCollectionReusableView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height = collectionView.bounds.height * 0.9
		return .init(width: height, height: height)
	}
}
