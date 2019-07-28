/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct UnsplashCollection : Codable {
	let id : Int?
	let title : String?
	let description : String?
	let publishedAt : String?
	let updatedAt : String?
	let curated : Bool?
	let featured : Bool?
	let totalPhotos : Int?
	let isPrivate : Bool?
	let shareKey : String?
	let tags : [Tag]?
	let links : Link?
	let user : User?
	let coverPhoto : CoverPhoto?
	let previewPhotos : [PreviewPhoto]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case description = "description"
		case publishedAt = "published_at"
		case updatedAt = "updated_at"
		case curated = "curated"
		case featured = "featured"
		case totalPhotos = "total_photos"
		case isPrivate = "private"
		case shareKey = "share_key"
		case tags = "tags"
		case links = "links"
		case user = "user"
		case coverPhoto = "cover_photo"
		case previewPhotos = "preview_photos"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		curated = try values.decodeIfPresent(Bool.self, forKey: .curated)
		featured = try values.decodeIfPresent(Bool.self, forKey: .featured)
		totalPhotos = try values.decodeIfPresent(Int.self, forKey: .totalPhotos)
		isPrivate = try values.decodeIfPresent(Bool.self, forKey: .isPrivate)
		shareKey = try values.decodeIfPresent(String.self, forKey: .shareKey)
		tags = try values.decodeIfPresent([Tag].self, forKey: .tags)
		links = try values.decodeIfPresent(Link.self, forKey: .links)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		coverPhoto = try values.decodeIfPresent(CoverPhoto.self, forKey: .coverPhoto)
		previewPhotos = try values.decodeIfPresent([PreviewPhoto].self, forKey: .previewPhotos)
	}

}

extension UnsplashCollection: Equatable {}
