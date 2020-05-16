//
//  OnboardingViewController.swift
//  Story Saver
//
//  Created by factboi on 14.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
	
	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var pageControl: UIPageControl!
	@IBOutlet private weak var nextButton: UIButton!
	
	private let features: [Feature] = [
		Feature(image: #imageLiteral(resourceName: "anonymity"), heading: "Keep It Secret.", subheading: "View the stories of a user anonymously."),
		Feature(image: #imageLiteral(resourceName: "arrows"), heading: "Instagram Stories Download", subheading: "Save the stories of your favorite users before they are deleted."),
		Feature(image: #imageLiteral(resourceName: "thumb"), heading: "Save your favourite profiles.", subheading: "Create your own list of profile you want to follow outside the Instagram."),
	]
	
	override func viewDidLoad() {	
		super.viewDidLoad()
		delegating()
		registerCells()
		addTargets()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		pageControl.numberOfPages = features.count
	}
	
	private func registerCells() {
		collectionView.register(OnboardingCollectionViewCell.nib, forCellWithReuseIdentifier: OnboardingCollectionViewCell.name)
		collectionView.register(PurchaseCollectionViewCell.nib, forCellWithReuseIdentifier: PurchaseCollectionViewCell.name)
	}
	
	private func delegating() {
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	private func addTargets() {
		nextButton.addTarget(self, action: #selector(nextButtonClicked(_:)), for: .touchUpInside)
	}
	
	@objc private func nextButtonClicked(_ sender: UIButton) {
		print("Tap")
	}
	
}



extension OnboardingViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return features.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.item == features.count {
			let purchaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: PurchaseCollectionViewCell.name, for: indexPath)
			return purchaseCell
		}
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.name, for: indexPath) as! OnboardingCollectionViewCell
		cell.feature = features[indexPath.item]
		return cell
	}
}

extension OnboardingViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		pageControl.currentPage = indexPath.item
		if indexPath.item == features.count {
			pageControl.alpha = 0
		} else {
			pageControl.alpha = 1
		}
	}
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		print(collectionView.bounds.size)
		return collectionView.bounds.size
	}
}
