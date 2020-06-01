//
//  OnboardingViewController.swift
//  Story Saver
//
//  Created by factboi on 14.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
	
	@IBOutlet weak var nextButton: UIButton!
	
	@IBOutlet var descriptionStackViews: [UIStackView]! {
		didSet {
			descriptionStackViews.forEach { (stackView) in
				stackView.subviews.forEach { (label) in
					if let label = label as? UILabel {
						label.adjustsFontSizeToFitWidth = true
					}
				}
			}
		}
	}
	
	var onNextButtonClicked: (() -> ())?
	
	@IBOutlet weak var whatsNewLabel: UILabel! {
		didSet {
			whatsNewLabel.adjustsFontSizeToFitWidth = true
		}
	}
	@IBOutlet weak var containerStackView: UIStackView!
	@IBAction func nextButtonClicked(_ sender: UIButton) {
		onNextButtonClicked?()
	}
	

	
	override func viewDidLoad() {
		super.viewDidLoad()
		containerStackView.subviews.forEach { (view) in
			view.transform = .init(translationX: view.frame.maxX + 100, y: 0)
		}
		
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		Decorator.decorate(self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		var delay = 0.5
		containerStackView.subviews.forEach { (view) in
			UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
				view.transform = .identity
			})
			delay += 0.2
		}
		navigationController?.setNavigationBarHidden(true, animated: false)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
}

extension OnboardingViewController {
	fileprivate final class Decorator {
		static func decorate(_ vc: OnboardingViewController) {
			vc.nextButton.round(value: 8)
		}
	}
}
