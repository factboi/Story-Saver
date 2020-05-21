//
//  StoryService.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSoup

class StoryService {
	func getStories(of user: User, completion: @escaping ([Story]?) -> Void) {
		let baseUrlString = "https://api.story.sybeta.tech/story/\(user.id)"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		
		_ = Alamofire.request(baseUrl).responseString(completionHandler: { (response) in
			let string = response.value ?? ""
			let json = JSON(parseJSON: string)
			let storiesJsonArray = json["data"]["stories"].arrayValue
			let jsonDecoder = JSONDecoder()
			let stories = storiesJsonArray.map { try? jsonDecoder.decode(Story.self, from: try! $0.rawData()) }.compactMap({$0})
			completion(stories)
		})
	}
	
}
