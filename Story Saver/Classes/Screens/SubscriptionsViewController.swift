//
//  SubscriptionsViewController.swift
//  Story Saver
//
//  Created by factboi on 28.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class SubscriptionsViewController: UIViewController {
	
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var restoreButton: UIButton!
	@IBOutlet weak var weekPriceButton: UIButton!
	@IBOutlet weak var monthPriceButton: UIButton!
	@IBOutlet weak var yearPriceButton: UIButton!
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	private func delegating() {
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
	private func registerCells() {
		//collectionView.register("", forCellWithReuseIdentifier: "123")
	}
	
	@IBAction func closeButtonClicked(_ sender: UIButton) {
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.popToRootViewController(animated: true)
	}
	
	@IBAction func restoreButtonClicked(_ sender: UIButton) {
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		Decorator.decorate(self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		closeButton.alpha = 0
		navigationController?.setNavigationBarHidden(true, animated: false)
		UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseOut, animations: {
			self.closeButton.alpha = 1
		})
	}
	
}

extension SubscriptionsViewController {
	fileprivate final class Decorator {
		static func decorate(_ vc: SubscriptionsViewController) {
			vc.weekPriceButton.round(value: 8)
			vc.monthPriceButton.round(value: 8)
			vc.yearPriceButton.round(value: 8)
		}
	}
}

extension SubscriptionsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return UICollectionViewCell()
	}
}

extension SubscriptionsViewController: UICollectionViewDelegate {
	
}
