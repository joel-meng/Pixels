/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CoverPhoto : Codable {
	let id : String?
	let createdAt : String?
	let updatedAt : String?
	let width : Int?
	let height : Int?
	let color : String?
	let description : String?
	let altDescription : String?
	let urls : Url?
	let links : Link?
	let categories : [String]?
	let sponsored : Bool?
	let sponsoredBy : String?
	let sponsoredImpressionsId : String?
	let likes : Int?
	let likedByUser : Bool?
	let currentUserCollections : [String]?
	let user : User?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case width = "width"
		case height = "height"
		case color = "color"
		case description = "description"
		case altDescription = "alt_description"
		case urls = "urls"
		case links = "links"
		case categories = "categories"
		case sponsored = "sponsored"
		case sponsoredBy = "sponsored_by"
		case sponsoredImpressionsId = "sponsored_impressions_id"
		case likes = "likes"
		case likedByUser = "liked_by_user"
		case currentUserCollections = "current_user_collections"
		case user = "user"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		color = try values.decodeIfPresent(String.self, forKey: .color)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		altDescription = try values.decodeIfPresent(String.self, forKey: .altDescription)
		urls = try values.decodeIfPresent(Url.self, forKey: .urls)
		links = try values.decodeIfPresent(Link.self, forKey: .links)
		categories = try values.decodeIfPresent([String].self, forKey: .categories)
		sponsored = try values.decodeIfPresent(Bool.self, forKey: .sponsored)
		sponsoredBy = try values.decodeIfPresent(String.self, forKey: .sponsoredBy)
		sponsoredImpressionsId = try values.decodeIfPresent(String.self, forKey: .sponsoredImpressionsId)
		likes = try values.decodeIfPresent(Int.self, forKey: .likes)
		likedByUser = try values.decodeIfPresent(Bool.self, forKey: .likedByUser)
		currentUserCollections = try values.decodeIfPresent([String].self, forKey: .currentUserCollections)
		user = try values.decodeIfPresent(User.self, forKey: .user)
	}

}
