//
//  SingleSectionTableDelegate.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit

class SingleSectionTableDelegate<T>: NSObject, UITableViewDataSource, UITableViewDelegate {

	/// Closure to configure an paticular tableview cell
	var cell: ((IndexPath, UITableView) -> UITableViewCell) = { _ , _  in
		return UITableViewCell(style: .default, reuseIdentifier: "")
	}

	/// Section Header
	var header: String?

	/// Tableview's content of items
	var items: [T] = []

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cell(indexPath, tableView)
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return header
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let selectedCell = tableView.cellForRow(at: indexPath) as? ReflexTableViewCell<T>
		selectedCell?.didTap?()
	}
}

