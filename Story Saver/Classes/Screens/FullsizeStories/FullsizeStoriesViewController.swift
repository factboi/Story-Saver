//
//  FullsizeStoriesViewController.swift
//  Story Saver
//
//  Created by factboi on 19.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class FullsizeStoriesViewController: UIViewController {
	
	private let selectedIndexPath: IndexPath
	private let stories: [Story]
	@IBOutlet private weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.register(FullsizeStoryCollectionViewCell.nib, forCellWithReuseIdentifier: FullsizeStoryCollectionViewCell.name)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.performBatchUpdates(nil) { (_) in
			self.collectionView.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
	
	init(stories: [Story], indexPath: IndexPath) {
		self.stories = stories
		self.selectedIndexPath = indexPath
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}

extension FullsizeStoriesViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return stories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullsizeStoryCollectionViewCell.name, for: indexPath) as! FullsizeStoryCollectionViewCell
		cell.set(stories[indexPath.item])
		return cell
	}
}

extension FullsizeStoriesViewController: UICollectionViewDelegate {
	
}

extension FullsizeStoriesViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.bounds.size
	}
}
