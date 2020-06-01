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
import WebKit


class UserService: NSObject {
	
	private let webView = WKWebView()
	
	private var imageCompletion: ((_ imageUrlString: String?) -> Void)?
	
	override init() {
		super.init()
		self.webView.navigationDelegate = self
	}
	
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
		webView.load(URLRequest(url: url))
		imageCompletion = { imageUrlString in
			guard let imageUrlString = imageUrlString else {
				completion(nil)
				return
			}
			guard let imageUrl = URL(string: imageUrlString) else {
				completion(nil)
				return
			}
			print(imageUrl)
			completion(imageUrl)
		}
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

extension UserService: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			webView.evaluateJavaScript("document.getElementsByClassName('download-btn')[0].toString()") { (html, error) in
				guard error == nil else {
					self.imageCompletion?(nil)
					return
				}
				guard let imageUrlString = html as? String else {
					self.imageCompletion?(nil)
					return
				}
				self.imageCompletion?(imageUrlString)
			}			
		}
	}
}
