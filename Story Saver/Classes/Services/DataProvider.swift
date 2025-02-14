//
//  DataProvider.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Foundation

class DataProvider {
	
	private let storyService = StoryService()
	private let userService = UserService()
	private let highlightsService = HighlightsService()
	
	func getUsers(_ username: String, completion: @escaping (([User]) -> Void)) {
		userService.getUsers(with: username) { (userJsonObject) in
			guard let users = userJsonObject?.map({$0.user}) else {
				completion([])
				return
			}
			completion(users)
		}
	}
	
	func getStories(_ user: User, completion: @escaping (([Story]) -> Void)){
		storyService.getStories(of: user) { (stories) in
			guard let stories = stories else {
				completion([])
				return
			}
			completion(stories)
		}
	}
	
	
	func getFullsizeProfileImage(_ user: User, completion: @escaping (URL?) -> Void) {
		userService.getFullSizeProfileImage(of: user, completion: completion)
	}
	
	func getDetailUserInfo(_ user: User, completion: @escaping (UserDetailInfo?) -> Void) {
		userService.getDetailedUserInfo(user) { (info) in
			guard let info = info else {
				completion(nil)
				return
			}
			completion(info)
		}
	}
	
	func getHighlightHtmlModels(_ user: User, completion: @escaping (([HighlightHtmlModel]) -> Void)) {
		highlightsService.getHighlightHtmlModels(of: user) { (htmlModels) in
			guard let htmlModels = htmlModels else {
				completion([])
				return
			}
			completion(htmlModels)
		}
	}
	
	func getHighlights(_ user: User, highlightsJsonModel: HighlightHtmlModel, completion: @escaping (([Highlight]) -> Void)) {
		highlightsService.getHighlights(of: user, highlightJsonModel: highlightsJsonModel) { (highlights) in
			guard let highlights = highlights else {
				completion([])
				return
			}
			completion(highlights)
		}
	}
	
	
	
}
