//
//  FullsizeImageViewController.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke

class FullsizeImageViewController: UIViewController {
	
	private let dataProvider = DataProvider()
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var dismissButton: UIButton!
	
	
	private let user: User
	private var profileUrl: URL?
	private lazy var alertViewController = AlertViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.backgroundColor = .black
		scrollView.delegate = self
		dataProvider.getFullsizeProfileImage(user) { (url) in
			if let url = url {
				print(url.absoluteString.count)
				Nuke.loadImage(with: url, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: self.imageView) { (_) in
					self.profileUrl = url
					self.setZoomParameters(self.scrollView.bounds.size)
					self.centerImage()
				}
			}
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setZoomParameters(scrollView.bounds.size)
		centerImage()
		Decorator.decorate(self)
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
	
	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .fullScreen
		modalTransitionStyle = .crossDissolve
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@IBAction func dismissButtonClicked(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
}

extension FullsizeImageViewController {
	fileprivate final class Decorator {
		static func decorate(_ vc: FullsizeImageViewController) {
			vc.dismissButton.round()
			vc.dismissButton.applyBorder(borderColor: .black, borderWidth: 0.5)
		}
	}
}


extension FullsizeImageViewController: UIScrollViewDelegate {
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
