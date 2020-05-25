//
//  Extension+UICollectionView.swift
//  Story Saver
//
//  Created by factboi on 25.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

extension UICollectionView {
	
	func setEmptyViewWithAnimation(emoji: String, message: String) {
		let bouncyView = BouncyView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))
		bouncyView.configure(emoji: emoji, message: message)
		backgroundView = bouncyView
	}
	
	func setEmptyViewWithMessage(_ message: String) {
		let titleLabel = UILabel(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))
		titleLabel.text = message
		titleLabel.textAlignment = .center
		titleLabel.textColor = .label
		titleLabel.font = .boldSystemFont(ofSize: 18)
		backgroundView = titleLabel
	}
	
	func restore() {
		backgroundView = nil
	}
}
