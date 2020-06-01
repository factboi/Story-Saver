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
		let emptyView = UIView(frame: bounds)
		let bouncyView = BouncyView(frame: CGRect(x: .zero, y: 300, width: bounds.width, height: bounds.height - 300))
		emptyView.addSubview(bouncyView)
		bouncyView.configure(emoji: emoji, message: message)
		backgroundView = emptyView
	}
	
	func setEmptyViewWithMessage(_ message: String) {
		let titleLabel = UILabel(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))
		titleLabel.text = message
		titleLabel.textAlignment = .center
		titleLabel.textColor = .black
		titleLabel.font = .boldSystemFont(ofSize: 18)
		backgroundView = titleLabel
	}
	
	func restore() {
		backgroundView = nil
	}
}
