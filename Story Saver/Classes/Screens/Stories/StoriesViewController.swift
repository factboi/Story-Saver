//
//  StoriesViewController.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {
	
	@IBOutlet private weak var collectionView: UICollectionView!
	
	private var stories: [Story] = []
	
	private let user: User
	
	private let dataProvider = DataProvider()
	
	private var userDetailInfo: UserDetailInfo?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = user.isVerified ? "\(user.username) ✅" : user.username
		navigationItem.largeTitleDisplayMode = .never
		delegating()
		registerClasses()
		getStories()
		getUserDetailInfo()
	}
	
	private func getStories() {
		if user.isPrivate {} else {
			dataProvider.getStories(user) { (stories) in
				self.stories = stories
				self.collectionView.reloadSections(IndexSet(integer: 0))
			}
		}
	}
	
	private func getUserDetailInfo() {
		dataProvider.getDetailUserInfo(user) { (userDetailInfo) in
			self.userDetailInfo = userDetailInfo
			self.collectionView.reloadSections(.init(integer: .zero))
		}
	}
	
	private func delegating() {
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	private func registerClasses() {
		collectionView.register(StoryCollectionViewCell.nib, forCellWithReuseIdentifier: StoryCollectionViewCell.name)
		collectionView.register(StoryHeaderCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoryHeaderCollectionReusableView.name)
	}
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension StoriesViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return stories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.name, for: indexPath) as! StoryCollectionViewCell
		let story = stories[indexPath.item]
		cell.set(story)
		print(indexPath.item)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StoryHeaderCollectionReusableView.name, for: indexPath) as! StoryHeaderCollectionReusableView
		header.onExpandButtonClicked = { [unowned self] in
			self.present(FullsizeImageViewController(user: self.user), animated: true)
		}
		if let info = userDetailInfo {
			header.set(info)
		}
		return header
	}
}

extension StoriesViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width - 32) / 3
		return .init(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		navigationController?.pushViewController(FullsizeStoriesViewController(stories: stories, indexPath: indexPath), animated: true)
	}
}

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return .init(width: view.bounds.width, height: view.bounds.height * 0.1)
	}
}
