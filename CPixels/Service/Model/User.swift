/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User : Codable {
	let id : String?
	let updatedAt : String?
	let username : String?
	let name : String?
	let firstName : String?
	let lastName : String?
	let twitterUsername : String?
	let portfolioUrl : String?
	let bio : String?
	let location : String?
	let links : Link?
	let profileImage : ProfileImage?
	let instagramUsername : String?
	let totalCollections : Int?
	let totalLikes : Int?
	let totalPhotos : Int?
	let acceptedTos : Bool?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case updatedAt = "updated_at"
		case username = "username"
		case name = "name"
		case firstName = "first_name"
		case lastName = "last_name"
		case twitterUsername = "twitter_username"
		case portfolioUrl = "portfolio_url"
		case bio = "bio"
		case location = "location"
		case links = "links"
		case profileImage = "profile_image"
		case instagramUsername = "instagram_username"
		case totalCollections = "total_collections"
		case totalLikes = "total_likes"
		case totalPhotos = "total_photos"
		case acceptedTos = "accepted_tos"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		twitterUsername = try values.decodeIfPresent(String.self, forKey: .twitterUsername)
		portfolioUrl = try values.decodeIfPresent(String.self, forKey: .portfolioUrl)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		links = try values.decodeIfPresent(Link.self, forKey: .links)
		profileImage = try values.decodeIfPresent(ProfileImage.self, forKey: .profileImage)
		instagramUsername = try values.decodeIfPresent(String.self, forKey: .instagramUsername)
		totalCollections = try values.decodeIfPresent(Int.self, forKey: .totalCollections)
		totalLikes = try values.decodeIfPresent(Int.self, forKey: .totalLikes)
		totalPhotos = try values.decodeIfPresent(Int.self, forKey: .totalPhotos)
		acceptedTos = try values.decodeIfPresent(Bool.self, forKey: .acceptedTos)
	}

}

extension User: Equatable {}
