//
//  StatedTableView.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit

final class StatedTableView: UIView {

	// MARK: - IBOutlet

	@IBOutlet var tableView: UITableView!

	@IBOutlet var messageLabel: UILabel!

	@IBOutlet var activityIndicator: UIActivityIndicatorView!

	@IBOutlet var contentView: UIView!

	// MARK: - Lifecycle methods

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	// MARK: - Setup

	private func setup() {
		// Load View
		Bundle.main.loadNibNamed(defaultNibName(), owner: self, options: nil)
		contentView.fixInView(self)
	}

	// MARK: - TableView Updater

	func updater<T, C: ReflexTableViewCell<T>>(bindAction: @escaping (T, C) -> Void) -> (_ state: StatedTableView.State<[T]>) -> Void {
		return customCellDataUpdater(for: self, bindAction)
	}

	// MARK: - UI State Control

	func updateState<T>(_ state: State<T>) {
		switch state {
		case .initial:
			showInitial()
		case .empty:
			showMessage("No data found. 🎁")
		case .data(let items):
			showCollection(items)
		case .error(let error):
			showMessage("\(error) 🎭")
		case .loading:
			showLoading()
		}
	}

	fileprivate func showInitial() {
		DispatchQueue.main.async { [weak tableView, activityIndicator, messageLabel] in
			tableView?.isHidden = true
			messageLabel?.isHidden = true
			activityIndicator?.isHidden = true
		}
	}

	fileprivate func showLoading() {
		DispatchQueue.main.async { [weak tableView, activityIndicator, messageLabel] in
			tableView?.isHidden = true
			messageLabel?.isHidden = true
			activityIndicator?.startAnimating()
			activityIndicator?.isHidden = false
		}
	}

	fileprivate func showCollection<T: Collection>(_ collection: T) {

		DispatchQueue.main.async { [weak tableView, activityIndicator, messageLabel] in
			tableView?.isHidden = false
			tableView?.reloadData()
			activityIndicator?.stopAnimating()
			activityIndicator?.isHidden = true
			messageLabel?.isHidden = true
			tableView?.reloadData()
		}
	}

	fileprivate func showMessage(_ message: String) {
		DispatchQueue.main.async { [weak tableView, activityIndicator, messageLabel] in
			messageLabel?.isHidden = false
			tableView?.isHidden = true
			activityIndicator?.stopAnimating()
			activityIndicator?.isHidden = false
		}
	}

	enum State<T: Collection> {
		case initial
		case loading
		case empty
		case data(T)
		case error(String)
	}
}

func customCellDataUpdater
	<T, C: ReflexTableViewCell<T>>(for statedTableView: StatedTableView, _ bindAction: @escaping (T, C) -> Void) -> (_ state: StatedTableView.State<[T]>) -> Void {

	let tableView = statedTableView.tableView

	tableView?.registerDefaultCell(for: T.self)

	// Bind tableview with data source and delegate
	let tableDataSourceAndDelegate = SingleSectionTableDelegate<T>()
	tableView?.dataSource = tableDataSourceAndDelegate
	tableView?.delegate = tableDataSourceAndDelegate

	return { [weak statedTableView] state in

		guard let statedTableView = statedTableView else { return }

		switch state {

		case .initial:
			statedTableView.showInitial()
		case .empty:
			statedTableView.showMessage("No data found. 🎁")

		case .error(let error):
			statedTableView.showMessage("\(error) 🎭")

		case .loading:
			statedTableView.showLoading()

		case .data(let items):
			tableDataSourceAndDelegate.items = items
			tableDataSourceAndDelegate.cell = { indexPath, tableView in

				let cell: C = tableView.dequeueDefaultReusableCell(forIndexPath: indexPath)

				let item = items[indexPath.row]

				cell.config(item)

				bindAction(item, cell)
				return cell
			}

			statedTableView.showCollection(items)
		}
	}
}
