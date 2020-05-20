//
//  UserDetailInfo.swift
//  Story Saver
//
//  Created by factboi on 18.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Foundation

struct UserDetailInfo: Decodable {
	let followersCount: EdgeFollowClass
	let followingCount: EdgeFollowClass
	let profilePicUrlHd: String
	let fullName: String
	private enum CodingKeys: String, CodingKey {
		case followersCount = "edge_followed_by"
		case followingCount = "edge_follow"
		case profilePicUrlHd = "profile_pic_url_hd"
		case fullName = "full_name"
	}
}

struct EdgeFollowClass: Decodable {
	let count: Int
}
