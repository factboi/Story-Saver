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
	private lazy var alertViewController = AlertViewController()
	private lazy var progressViewController =  ProgressViewController()
	private lazy var videoDownloadService: VideoDownloadService = {
		let service = VideoDownloadService()
		service.delegate = self
		return service
	}()
	
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
	
	private func presentAlert(_ highlight: Highlight) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		let saveAction = UIAlertAction(title: "Save to gallery", style: .default) { (alert) in
			if let highlightImageUrlString = highlight.imageUrlString {
				if let imageUrl = URL(string: highlightImageUrlString) {
					self.handleImageSave(with: imageUrl)
				}
			} else if let highlightVideoUrlString = highlight.videoUrlString {
				if let videoUrl = URL(string: highlightVideoUrlString) {
					self.handleVideoSave(with: videoUrl)
				}
			}
		}
		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)
		alertController.view.tintColor = .black
		present(alertController, animated: true)
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
	
	init(user: User, highlightJsonModel: HighlightJsonModel) {
		self.highlightJsonModel = highlightJsonModel
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension FullsizeHighlightsViewController: VideoDownloadServiceDelegate {
	func progressDidChanged(_ progress: CGFloat) {
		progressViewController.progress = progress
	}
}

extension FullsizeHighlightsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		highlights.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightCollectionViewCell.name, for: indexPath) as! HighlightCollectionViewCell
		cell.highlight = highlights[indexPath.item]
		cell.onDownloadButtonClicked = { [weak self] highlight in
			self?.presentAlert(highlight)
		}
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
