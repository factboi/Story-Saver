//
//  DummyViewController.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class HighlightsPreviewViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	private let dataProvider = DataProvider()
	private let user: User
	private var highlightJsonModels: [HighlightHtmlModel] = []
	
	var onHighlightPreviewTapped: ((_ user: User, _ highlightJsonModel: HighlightHtmlModel) -> Void)?

	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(HighlightPreviewCollectionViewCell.nib, forCellWithReuseIdentifier: HighlightPreviewCollectionViewCell.name)
		dataProvider.getHighlightHtmlModels(user) { (highlightJsonModels) in
			print("get")
			self.highlightJsonModels = highlightJsonModels
			self.collectionView.reloadSections(.init(integer: .zero))
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print(#function)
	}
	
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	
}

extension HighlightsPreviewViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return highlightJsonModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightPreviewCollectionViewCell.name, for: indexPath) as! HighlightPreviewCollectionViewCell
		cell.set(highlightJsonModels[indexPath.item])
		return cell
	}
}

extension HighlightsPreviewViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		onHighlightPreviewTapped?(user, highlightJsonModels[indexPath.item])
	}
}

extension HighlightsPreviewViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height = collectionView.bounds.height * 0.9
		return .init(width: height, height: height)
	}
}
