//
//  UIView+Nib.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit

extension UIView {
	
	func defaultNibName() -> String {
		return type(of: self).description().components(separatedBy: ".").last!
	}

	func loadNib() -> UIView {
		let bundle = Bundle(for: type(of: self))
		let nibName = defaultNibName()
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as! UIView
	}
}
