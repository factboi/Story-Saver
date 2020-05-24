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
	func getHighlightHtmlModels(of user: User, completion: @escaping ([HighlightHtmlModel]?) -> Void) {
		let baseUrlString = "https://www.insta-stories.com/en/stories/\(user.username)"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		_ = Alamofire.request(baseUrl).responseString(completionHandler: { (response) in
			let htmlString = response.value ?? ""
			let doc = try? SwiftSoup.parse(htmlString)
			let thumbnails = try? doc?.getElementsByClass("highlight col-6 col-md-3 mb-4 mb-md-5").array()
			var elements: [Element] = []
			thumbnails?.forEach({ (element) in
				if let aTag = try? element.getElementsByTag("a").first() {
					elements.append(aTag)
				}
			})
			var highlights: [HighlightHtmlModel] = []
			elements.forEach { (element) in
				let id = try? element.attr("href").components(separatedBy: "/").last
				let imgUrlString = try? element.getElementsByTag("img").first()?.attr("src")
				let title = try? element.getElementsByClass("highlight-description").text()
				if let id = id, let imageUrlString = imgUrlString, let title = title {
					let highlight = HighlightHtmlModel(id: id, title: title, imageUrlString: imageUrlString)
					highlights.append(highlight)
				}
			}
			completion(highlights)
		})
	}
	
	func getHighlights(of user: User, highlightJsonModel: HighlightHtmlModel, completion: @escaping ([Highlight]?) -> Void) {
		guard let id  = highlightJsonModel.id.components(separatedBy: ":").last else {
			completion(nil)
			return
		}
		let baseUrlString = "https://www.insta-stories.com/en/stories/\(user.username)/\(id)"
		guard let baseUrl = URL(string: baseUrlString) else {
			completion(nil)
			return
		}
		
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
			completion(highlightsArray)
		})
	}
}
