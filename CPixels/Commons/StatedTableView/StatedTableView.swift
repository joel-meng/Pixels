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

	@IBOutlet var tableView: UITableView! {
		didSet {
			tableView.separatorStyle = .none
			tableView.contentInsetAdjustmentBehavior = .never
		}
	}

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
		Bundle.main.loadNibNamed(defaultNibName(), owner: self, options: nil)
		contentView.fixInView(self)
	}

	// MARK: - TableView Updater

	func updater<T>(bindAction: @escaping (T, ReflexTableViewCell<T>) -> Void) -> (_ state: StatedTableView.State<[T]>) -> Void {
		tableView.registerDefaultCell(for: T.self)
		return customCellDataUpdater(for: self, bindAction)
	}

	// MARK: - UI State Control

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
	<T>(for statedTableView: StatedTableView, _ bindAction: @escaping (T, ReflexTableViewCell<T>) -> Void) -> (_ state: StatedTableView.State<[T]>) -> Void {

	guard let tableView = statedTableView.tableView else {
		return { _ in }
	}

	let tableDataSourceAndDelegate = SingleSectionTableDelegate<T>()
	tableView.dataSource = tableDataSourceAndDelegate
	tableView.delegate = tableDataSourceAndDelegate

	tableDataSourceAndDelegate.cell = { cell, item in
		cell.config(item)
		bindAction(item, cell)
		return cell
	}

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
			statedTableView.showCollection(items)
		}
	}
}
