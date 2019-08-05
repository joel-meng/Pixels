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
	var cell: ((ReflexTableViewCell<T>, T) -> UITableViewCell) = { _ , _ in
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
		return 100
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let dequeuedCell = tableView.dequeueDefaultReusableCell(forIndexPath: indexPath) as ReflexTableViewCell<T>
		if indexPath.row < items.count {
			return cell(dequeuedCell, items[indexPath.row])
		}
		return UITableViewCell(style: .default, reuseIdentifier: "no")
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return header
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let selectedCell = tableView.cellForRow(at: indexPath) as? ReflexTableViewCell<T>
		selectedCell?.didTap?(items[indexPath.row])
	}
}

