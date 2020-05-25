//
//  SearchUserTableViewCell.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Nuke

class SearchUserTableViewCell: UITableViewCell, NibLoadable {
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		Decorator.decorate(self)
	}
	
	public func set(_ user: User) {
		if let imageUrl = URL(string: user.profilePicUrl) {
			Nuke.loadImage(with: imageUrl, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.3, options: .curveEaseOut)), into: profileImageView)
		}
		usernameLabel.text = user.isVerified ? "\(user.username) ✅" : user.username
		nameLabel.text = user.fullName
		nameLabel.isHidden = user.fullName.isEmpty
	}
	
}

extension SearchUserTableViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: SearchUserTableViewCell) {
			cell.profileImageView.round()
		}
	}
}
