//
//  Extension+UIView.swift
//  Story Saver
//
//  Created by factboi on 15.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

extension UIView {
	func round(value: CGFloat? = nil) {
		layer.cornerRadius = value ?? bounds.height * 0.5
	}
	
	func applyBorder(borderColor: UIColor, borderWidth: CGFloat? = nil) {
		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderWidth ?? 1
	}
}
