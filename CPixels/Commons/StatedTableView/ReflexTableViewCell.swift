//
//  ReusableTableViewCell.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit

class ReflexTableViewCell<T>: UITableViewCell {

	/// This function will be called when cell is tapped
	var didTap: ((T) -> Void)?

	open override func prepareForReuse() {
		didTap = nil
	}

	open func config(_ item: T) {
		// Leave this function to be overriden by subclass.
		fatalError("Must to override config method")
	}
}
