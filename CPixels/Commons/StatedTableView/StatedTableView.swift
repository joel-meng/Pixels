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

	lazy var preFetchingDS: FeaturedCollectionDataSourcePrefetching = FeaturedCollectionDataSourcePrefetching()

	@IBOutlet var tableView: UITableView! {
		didSet {
			tableView.separatorStyle = .none
			tableView.prefetchDataSource = preFetchingDS
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

	func tapAction<T>(bindAction: @escaping (T) -> Void) -> (_ state: StatedTableView.State<[T]>) -> Void {
		tableView.registerDefaultCell(for: T.self)
		return customCellDataUpdater(for: self, bindAction: bindAction)
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

		static func fromRestFetchState<D: Collection>(_ state: [Int: RestFetchingState<D>]) -> State {

			if state.isEmpty {
				return .initial
			}

			if state.count == 1, case .loading? = state.first?.value {
				return StatedTableView.State<T>.loading
			}

			let readyCollections = state.values.compactMap { (collectionState) -> D? in
				if case .ready(let collection) = collectionState {
					return collection
				}
				return nil
			}.flatMap { $0 }

			if readyCollections.isEmpty {
				return .empty
			}

			print("ready collections: \((readyCollections as! [UnsplashCollection]).first?.title)")
			return .data(readyCollections as! T)

		}
	}
}

func customCellDataUpdater
	<T>(for statedTableView: StatedTableView,
		bindAction: @escaping (T) -> Void) -> (_ state: StatedTableView.State<[T]>) -> Void {

	guard let tableView = statedTableView.tableView else {
		return { _ in }
	}

	let tableDataSourceAndDelegate = SingleSectionTableDelegate<T>()
	tableView.dataSource = tableDataSourceAndDelegate
	tableView.delegate = tableDataSourceAndDelegate

	tableDataSourceAndDelegate.cell = { cell, item in
		cell.config(item)
		cell.didTap = bindAction
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

final class FeaturedCollectionDataSourcePrefetching: NSObject, UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		let pages = indexPaths.reduce(into: Set<Int>()) { (result, indexPath) in
//			print("prefetch \(indexPath.row)")
			result.insert(indexPath.row / 10 + 1)
		}
		pages.forEach { (page) in
//			print("dispatching loading request for page \(page)")
			store.dispatch(fetchCollection(collectionPerPage: 10, page: page))
		}
	}
}
