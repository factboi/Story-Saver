//
//  StoriesViewController.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {
	
	private let headerViewMaxHeight: CGFloat = 350
	private let headerViewMinHeight: CGFloat = 90
	
	@IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet private weak var collectionView: UICollectionView!
	
	
	private var stories: [Story] = []
	private let user: User
	private let dataProvider = DataProvider()
	private var userDetailInfo: UserDetailInfo?
	private var highlightHtmlModels: [HighlightHtmlModel]?
	private let refreshControl = UIRefreshControl()
	private lazy var alertViewController = AlertViewController()
	private lazy var progressViewController =  ProgressViewController()
	private lazy var videoDownloadService: VideoDownloadService = {
		let service = VideoDownloadService()
		service.delegate = self
		return service
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = user.isVerified ? "\(user.username) ✅" : user.username
		navigationItem.largeTitleDisplayMode = .never
		refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
		collectionView.refreshControl = refreshControl
		delegating()
		registerClasses()
		getStories()
		getUserDetailInfo()
		getHighlightHtmlModels()
	}
	
	@objc private func refresh(_ sender: UIRefreshControl) {
		getStories()
		sender.endRefreshing()
	}
	
	private func getStories() {
		if user.isPrivate {} else {
			dataProvider.getStories(user) { (stories) in
				self.stories = stories
				self.collectionView.reloadSections(IndexSet(integer: 0))
			}
		}
	}
	
	private func getHighlightHtmlModels() {
		if user.isPrivate {} else {
			dataProvider.getHighlightHtmlModels(user) { (highlightHtmlModels) in
				self.highlightHtmlModels = highlightHtmlModels
				self.collectionView.reloadSections(.init(integer: .zero))
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
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	private func presentAlert(_ story: Story) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		let saveAction = UIAlertAction(title: "Save to gallery", style: .default) { (alert) in
			if !story.video.isEmpty {
				if let storyVideoUrl = URL(string: story.video) {
					self.handleVideoSave(with: storyVideoUrl)
				}
			} else {
				if let storyImageUrl = URL(string: story.preview) {
					self.handleImageSave(with: storyImageUrl)
				}
			}
		}
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)
		self.present(alertController, animated: true)
	}
	
	private func handleImageSave(with url: URL) {
		ImageDownloadService.shared.saveImage(url, completion: { (error) in
			if error == nil {
				self.alertViewController.state = State.success
				self.present(self.alertViewController, animated: true)
			} else {
				switch error {
					case .accessDenied:
						self.alertViewController.state = State.accessDenied
						self.present(self.alertViewController, animated: true)
					case .unknown:
						self.alertViewController.state = State.unknown
						self.present(self.alertViewController, animated: true)
					case .none: break
				}
			}
		})
	}
	
	private func handleVideoSave(with url: URL) {
		
		self.present(self.progressViewController, animated: true, completion: nil)
		self.videoDownloadService.downloadAndSave(videoUrl: url) { (error) in
			switch error {
				case nil:
					DispatchQueue.main.async {
						self.progressViewController.didFinished = (error == nil)
					}
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
						self.progressViewController.dismiss(animated: true) {
							self.progressViewController.progress = 0
						}
					})
				case .accessDenied:
					DispatchQueue.main.async {
						self.progressViewController.dismiss(animated: true) {
							self.progressViewController.progress = 0
						}
					}
					self.alertViewController.state = State.accessDenied
					DispatchQueue.main.async {
						self.present(self.alertViewController, animated: true)
				}
				case .unknown:
					DispatchQueue.main.async {
						self.progressViewController.dismiss(animated: true) {
							self.progressViewController.progress = 0
						}
					}
					self.alertViewController.state = State.unknown
					DispatchQueue.main.async {
						self.present(self.alertViewController, animated: true)
				}
			}
		}
	}
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension StoriesViewController: VideoDownloadServiceDelegate {
	func progressDidChanged(_ progress: CGFloat) {
		progressViewController.progress = progress
	}
}

extension StoriesViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return stories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.name, for: indexPath) as! StoryCollectionViewCell
		let story = stories[indexPath.item]
		cell.story = story
		cell.onDownloadClicked = { [weak self] story in
			self?.presentAlert(story)
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StoryHeaderCollectionReusableView.name, for: indexPath) as! StoryHeaderCollectionReusableView
		header.onExpandButtonClicked = { [weak self] in
			if let user = self?.user {
				self?.present(FullsizeImageViewController(user: user), animated: true)
			}
		}

		header.onHighlightPreviewTapped = { [weak self] user, highlightHtmlModel in
			self?.navigationController?.pushViewController(FullsizeHighlightsViewController(user: user, highlightJsonModel: highlightHtmlModel), animated: true)
		}
		
		if let info = userDetailInfo, let highlightsHtmlModels = highlightHtmlModels {
			header.set(info, user: user, highlightsHtmlModels: highlightsHtmlModels)
		}
		
		return header
	}
}

extension StoriesViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let story = stories[indexPath.item]

		story.video.isEmpty ? present(FullsizeImageStoryViewController(contentUrlString: story.preview), animated: true) : playVideoByUrl(story.video)
	}
}

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width - 32) / 3
		return .init(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		
		return .init(width: view.bounds.width, height: 300)
	}
}
