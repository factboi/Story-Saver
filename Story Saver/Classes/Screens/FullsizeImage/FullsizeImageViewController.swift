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
	
	@IBOutlet weak var shareButton: UIButton! {
		didSet {
			shareButton.isEnabled = false
			shareButton.alpha = 0
		}
	}
	
	private let user: User
	private var profileUrl: URL?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.backgroundColor = .black
		scrollView.delegate = self
		dataProvider.getFullsizeProfileImage(user) { (url) in
			if let url = url {
				guard url.absoluteString.count > 30 else {
					let alert = UIAlertController(title: "Ooops!", message: "Error occured, please try again.", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alert, animated: true)
					return
				}
				Nuke.loadImage(with: url, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: self.imageView) { (_) in
					self.profileUrl = url
					self.setZoomParameters(self.scrollView.bounds.size)
					self.centerImage()
					UIView.animate(withDuration: 0.3) {
						self.shareButton.alpha = 1
						self.shareButton.isEnabled = true
					}
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
	
	@IBAction func shareButtonClicked(_ sender: UIButton) {
		if let image = imageView.image {
			let activityViewController = UIActivityViewController(activityItems: [image] , applicationActivities: nil)
			activityViewController.popoverPresentationController?.sourceView = self.view
			self.present(activityViewController, animated: true)
		}
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
			vc.shareButton.round()
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
