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
	
	private let user: User
	
	private func delegating() {
		scrollView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegating()
		scrollView.minimumZoomScale = 1
		scrollView.zoomScale = 1
		scrollView.maximumZoomScale = 5
		dataProvider.getFullsizeProfileImage(user) { (url) in
			if let url = url {
				Nuke.loadImage(with: url, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: self.imageView)
			} else {
				self.dataProvider.getDetailUserInfo(self.user) { (info) in
					if let info = info {
						if let url = URL(string: info.profilePicUrlHd) {
							Nuke.loadImage(with: url, options: .init(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: self.imageView)
						}
					}
				}
			}
		}
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

extension FullsizeImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}

