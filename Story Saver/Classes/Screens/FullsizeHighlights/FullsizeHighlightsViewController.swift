//
//  FullsizeHighlightsViewController.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class FullsizeHighlightsViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	private let highlightJsonModel: HighlightJsonModel
	private let dataProvider = DataProvider()
	private var highlights: [Highlight] = []
	private let user: User
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(HighlightCollectionViewCell.nib, forCellWithReuseIdentifier: HighlightCollectionViewCell.name)
		title = highlightJsonModel.title
		dataProvider.getHighlights(user, highlightsJsonModel: highlightJsonModel) { (highlights) in
			self.highlights = highlights
			self.collectionView.reloadSections(.init(integer: .zero))
		}
	}
	
	
	init(user: User, highlightJsonModel: HighlightJsonModel) {
		self.highlightJsonModel = highlightJsonModel
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension FullsizeHighlightsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		highlights.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightCollectionViewCell.name, for: indexPath) as! HighlightCollectionViewCell
		cell.set(highlight: highlights[indexPath.item])
		return cell
	}
	
	
}

extension FullsizeHighlightsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let highlight = highlights[indexPath.item]
		if let videoUrlString = highlight.videoUrlString {
			playVideoByUrl(videoUrlString)
		} else if let imageUrlString = highlight.imageUrlString {
			print("\(imageUrlString)")
		}
	}
}

extension FullsizeHighlightsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width - 32) / 3
		return .init(width: width, height: width)
	}
}
