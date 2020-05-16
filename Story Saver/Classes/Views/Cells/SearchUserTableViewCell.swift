//
//  SearchUserTableViewCell.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell, NibLoadable {
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		Decorator.decorate(self)
	}

}

extension SearchUserTableViewCell {
	fileprivate final class Decorator {
		static func decorate(_ cell: SearchUserTableViewCell) {
			cell.profileImageView.round()
		}
	}
}
