//
//  NibLoadable.swift
//  Story Saver
//
//  Created by factboi on 15.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
  static var nib: UINib { get }
	static var name: String { get }
}

public extension NibLoadable {
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }
	static var name: String {
		return String(describing: self)
	}
}

public extension NibLoadable where Self: UIView {
  static func loadFromNib() -> Self {
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError("The nib \(nib) expected its root view to be of type \(self)")
    }
    return view
  }
}
