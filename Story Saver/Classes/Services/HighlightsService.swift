//
//  HighlightsService.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup
import SwiftyJSON

class HighlightsService {
	func getHighlightJsonModels(of user: User, completion: @escaping ([HighlightJsonModel]?) -> Void) {
		let baseUrlString = "https://api.storiesig.com/highlights/\(user.username)"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		_ = Alamofire.request(baseUrl).responseString(completionHandler: { (response) in
			let string = response.value ?? ""
			let json = JSON(parseJSON: string)
			let highlightsJsonArray = json["tray"].arrayValue
			
			let jsonDecoder = JSONDecoder()
			let highlights = highlightsJsonArray.map { try? jsonDecoder.decode(HighlightJsonModel.self, from: try! $0.rawData()) }.compactMap({$0})
			completion(highlights)
		})
	}
	
	func getHighlights(of user: User, highlightJsonModel: HighlightJsonModel, completion: @escaping ([Highlight]?) -> Void) {
		guard let id  = highlightJsonModel.id.components(separatedBy: ":").last else {
			completion(nil)
			return
		}
		let baseUrlString = "https://www.insta-stories.com/en/stories/\(user.username)/\(id)"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		print(baseUrl)
		
		_ = Alamofire.request(baseUrl).responseString(completionHandler: { (response) in
			let htmlString = response.value ?? ""
			let doc = try? SwiftSoup.parse(htmlString)
			let highlights = try? doc?.getElementsByClass("story").array()
			var highlightsArray: [Highlight] = []
			highlights?.forEach({ (highlight) in
				if let imageObject = try? highlight.getElementsByTag("img").first() {
					let image = try? imageObject.attr("src")
					let story = Highlight(imageUrlString: image, videoUrlString: nil)
					highlightsArray.append(story)
				} else if let videoObject = try? highlight.getElementsByTag("video").first() {
					let video = try? videoObject.attr("src")
					let story = Highlight(imageUrlString: nil, videoUrlString: video)
					highlightsArray.append(story)
				}
			})
			print(highlightsArray)
			completion(highlightsArray)
		})
	}
}
