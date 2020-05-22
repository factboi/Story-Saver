//
//  FullsizeImageStoryViewController.swift
//  Story Saver
//
//  Created by factboi on 20.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke

class FullsizeImageStoryViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var closeButton: UIButton!
	
	private let contentUrlString: String
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
		loadImage()
	}
	
	private func loadImage() {
		if let contentUrl = URL(string: contentUrlString) {
			Nuke.loadImage(with: contentUrl, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)),into: imageView) { (_) in
				self.setZoomParameters(self.scrollView.bounds.size)
				self.centerImage()
			}
		}
	}
	
	func setZoomParameters(_ scrollViewSize: CGSize) {
		let imageSize = imageView.bounds.size
		let widthScale = scrollViewSize.width / imageSize.width
		let heightScale = scrollViewSize.height / imageSize.height
		let minScale = min(widthScale, heightScale)
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 2
		scrollView.setZoomScale(minScale, animated: true)
	}
	
	
	
	func centerImage() {
		let scrollViewSize = scrollView.bounds.size
		let imageSize = imageView.frame.size
		let horizontalSpace = imageSize.width < scrollViewSize.width ?
			(scrollViewSize.width - imageSize.width) / 2 : 0
		let verticalSpace = imageSize.height < scrollViewSize.height ?
		(scrollViewSize.height - imageSize.height) / 2 : 0
		scrollView.contentInset = .init(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
	}
	
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		centerImage()
		setZoomParameters(scrollView.bounds.size)
		Decorator.decorate(self)
	}
	
	@IBAction func dismissButtonClicked(_ sender: UIButton) {
		dismiss(animated: true)
	}
	init(contentUrlString: String) {
		self.contentUrlString = contentUrlString
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .fullScreen
		modalTransitionStyle = .crossDissolve
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension FullsizeImageStoryViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerImage()
	}
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		setZoomParameters(scrollView.bounds.size)
	}
}

extension FullsizeImageStoryViewController {
	fileprivate final class Decorator {
		static func decorate(_ vc: FullsizeImageStoryViewController) {
			vc.closeButton.round()
			vc.closeButton.applyBorder(borderColor: .black, borderWidth: 0.5)
		}
	}
}
