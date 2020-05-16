//
//  OnboardingCollectionViewCell.swift
//  Story Saver
//
//  Created by factboi on 15.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell, NibLoadable {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var headingLabel: UILabel! {
		didSet {
			headingLabel.adjustsFontSizeToFitWidth = true
		}
	}
	@IBOutlet weak var subheadingLabel: UILabel! {
		didSet {
			subheadingLabel.adjustsFontSizeToFitWidth = true
		}
	}
	
	public var feature: Feature? {
		didSet {
			if let feature = feature {
				imageView.image = feature.image
				headingLabel.text = feature.heading
				subheadingLabel.text = feature.subheading
			}
		}
	}
}
