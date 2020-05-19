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
	
	private var users: [User] = []
	private let dataProvider = DataProvider()
	
	private let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegating()
		registerCells()
		setupNavBar()
	}
	
	private func registerCells() {
		tableView.register(SearchUserTableViewCell.nib, forCellReuseIdentifier: SearchUserTableViewCell.name)
	}
	
	private func setupNavBar() {
		title = "Search"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search Users"
		searchController.searchBar.autocapitalizationType = .none
		searchController.searchBar.autocorrectionType = .no
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.keyboardType = .webSearch
		searchController.definesPresentationContext = true
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		searchController.searchBar.resignFirstResponder()
	}
	
}

extension ViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		users.removeAll()
		if let username = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
			dataProvider.getUsers(username) { (users) in
				self.users = users
				self.tableView.reloadSections([0], with: .fade)
			}
		}
		searchBar.resignFirstResponder()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		users.removeAll()
		self.tableView.reloadSections([0], with: .fade)
	}
	
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.name, for: indexPath) as! SearchUserTableViewCell
		cell.set(users[indexPath.item])
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: self, action: nil)
		navigationController?.pushViewController(StoriesViewController(user: users[indexPath.item]), animated: true)
	}
}

