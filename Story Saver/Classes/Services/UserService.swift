//
//  UserService.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Foundation
import SwiftSoup

class UserService {
	func getUsers(with profileName: String, completion: @escaping ([UserJsonObject]?) -> Void) {
		let baseUrlString = "https://i.instagram.com/web/search/topsearch/?query=\(profileName)"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		
		_ = Alamofire.request(baseUrl).responseString(completionHandler: { (response) in
			let string = response.value ?? ""
			let json = JSON(parseJSON: string)
			let usersJsonObject = json["users"].arrayValue
			let jsonDecoder = JSONDecoder()
			let userObjects = usersJsonObject.map { try? jsonDecoder.decode(UserJsonObject.self, from: try! $0.rawData()) }.compactMap({$0})
			completion(userObjects)
		})
	}
	
	func getFullSizeProfileImage(of user: User, completion: @escaping (URL?) -> Void) {
		let baseUrlString = "https://www.instadp.com/fullsize/\(user.username)"
		guard let url = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		
		_ = Alamofire.request(url).responseString(completionHandler: { (response) in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				let string = response.value ?? ""
				let document = try? SwiftSoup.parse(string)
				let pictureClass = try? document?.getElementsByClass("download-btn").first()
				guard let source = try? pictureClass?.attr("href") else {
					completion(nil)
					return
				}
				
				guard !source.isEmpty else {
					completion(nil)
					return
				}
				
				guard let url = URL(string: source) else {
					completion(nil)
					return
				}
				completion(url)
			}
		})
	}
	
	func getDetailedUserInfo(_ user: User, completion: @escaping (UserDetailInfo?) -> Void) {
		let baseUrlString = "https://www.instagram.com/\(user.username)/?__a=1"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		_ = Alamofire.request(baseUrl).responseString(completionHandler: { (response) in
			let string = response.value ?? ""
			let json = JSON(parseJSON: string)
			guard let userJson = try? json["graphql"]["user"].rawData() else {
				completion(nil)
				return
			}
			let userDetailInfo = try? JSONDecoder().decode(UserDetailInfo.self, from: userJson)
			completion(userDetailInfo)
		})
	}
	
}


