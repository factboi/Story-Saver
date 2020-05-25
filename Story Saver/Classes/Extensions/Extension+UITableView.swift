//
//  Extension+UITableView.swift
//  Story Saver
//
//  Created by factboi on 25.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

extension UITableView {
	func setEmptyView(emoji: String, message: String) {
		let bouncyView = BouncyView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))
		bouncyView.configure(emoji: emoji, message: message)
		backgroundView = bouncyView
		separatorStyle = .none
	}
	func restore() {
		backgroundView = nil
		separatorStyle = .singleLine
	}
}
