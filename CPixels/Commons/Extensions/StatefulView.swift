//
//  StatefulView.swift
//  CPixels
//
//  Created by Joel Meng on 8/3/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit

protocol StatefulView {

	var mainView: UIView! { get }

	var messageLabel: UILabel! { get }

	var activityIndicator: UIActivityIndicatorView! { get }
}

enum ViewState<SV: StatefulView> {
	case uninitialized
	case loading
	case loaded
	case error
	case empty

	func update(view: StatefulView) {
		switch self {

		case .loading, .uninitialized:
			view.activityIndicator.startAnimating()
			view.activityIndicator.isHidden = false
			view.messageLabel.isHidden = true
			view.mainView.isHidden = true

		case .loaded:
			view.activityIndicator.stopAnimating()
			view.activityIndicator.isHidden = true
			view.messageLabel.isHidden = true
			view.mainView.isHidden = false

		case .empty:
			view.activityIndicator.stopAnimating()
			view.activityIndicator.isHidden = true
			view.messageLabel.isHidden = false
			view.mainView.isHidden = true

		case .error:
			view.activityIndicator.startAnimating()
			view.activityIndicator.isHidden = true
			view.messageLabel.isHidden = false
			view.mainView.isHidden = true
		}
	}
}
