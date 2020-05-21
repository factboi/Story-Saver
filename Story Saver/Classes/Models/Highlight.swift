//
//  Highlight.swift
//  Story Saver
//
//  Created by factboi on 20.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Foundation

struct Highlight {
	let imageUrlString: String?
	let videoUrlString: String?
}

struct HighlightJsonModel: Decodable {
	let id: String
	let title: String
	let coverMedia: CoverMedia
	private enum CodingKeys: String, CodingKey {
		case id
		case title
		case coverMedia = "cover_media"
	}
}

struct CoverMedia: Decodable {
	let croppedImageVersion: CroppedImageVersion
	private enum CodingKeys: String, CodingKey {
		case croppedImageVersion = "cropped_image_version"
	}
}

struct CroppedImageVersion: Decodable {
	let url: String
}
