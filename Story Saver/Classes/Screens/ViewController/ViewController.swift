//
//  ViewController.swift
//  Story Saver
//
//  Created by factboi on 14.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet private weak var tableView: UITableView! {
		didSet {
			tableView.tableFooterView = UIView()
		}
	}
	
	private var users: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegating()
		registerCells()
	}

	private func registerCells() {
		tableView.register(SearchUserTableViewCell.nib, forCellReuseIdentifier: SearchUserTableViewCell.name)
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 15
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.name, for: indexPath) as! SearchUserTableViewCell
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

