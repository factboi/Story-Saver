//
//  User.swift
//  Story Saver
//
//  Created by factboi on 17.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

struct UserJsonObject: Decodable {
	let user: User
}

class User: Decodable {
	let id: String
	let username: String
	let fullName: String
	let isPrivate: Bool
	let profilePicUrl: String
	let isVerified: Bool
	
	private enum CodingKeys: String, CodingKey {
		case id = "pk"
		case username
		case fullName = "full_name"
		case isPrivate = "is_private"
		case profilePicUrl = "profile_pic_url"
		case isVerified = "is_verified"
	}
}
