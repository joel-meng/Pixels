/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Link : Codable {
	let selfLink : String?
	let html : String?
	let photos : String?
	let likes : String?
	let portfolio : String?
	let following : String?
	let followers : String?

	enum CodingKeys: String, CodingKey {

		case selfLink = "self"
		case html = "html"
		case photos = "photos"
		case likes = "likes"
		case portfolio = "portfolio"
		case following = "following"
		case followers = "followers"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		selfLink = try values.decodeIfPresent(String.self, forKey: .selfLink)
		html = try values.decodeIfPresent(String.self, forKey: .html)
		photos = try values.decodeIfPresent(String.self, forKey: .photos)
		likes = try values.decodeIfPresent(String.self, forKey: .likes)
		portfolio = try values.decodeIfPresent(String.self, forKey: .portfolio)
		following = try values.decodeIfPresent(String.self, forKey: .following)
		followers = try values.decodeIfPresent(String.self, forKey: .followers)
	}

}

extension Link: Equatable {}
