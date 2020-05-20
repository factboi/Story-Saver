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
	
	private let story: Story
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let imageUrl = URL(string: story.preview) {
			Nuke.loadImage(with: imageUrl, options: .init(transition: .fadeIn(duration: 0.3)),into: imageView)			
		}
		closeButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
	}
	
	@objc private func dismissButtonPressed(_ sender: UIButton) {
		dismiss(animated: true)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		Decorator.decorate(self)
	}
	
	init(story: Story) {
		self.story = story
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .fullScreen
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
}

extension FullsizeImageStoryViewController {
	fileprivate final class Decorator {
		static func decorate(_ vc: FullsizeImageStoryViewController) {
			vc.closeButton.round()
		}
	}
}
