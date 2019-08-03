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

		var completion:  () -> Void

		switch self {

		case .loading, .uninitialized:
			completion = {
				view.activityIndicator.startAnimating()
				view.activityIndicator.isHidden = false
				view.messageLabel.isHidden = true
				view.mainView.isHidden = true
			}

		case .loaded:
			completion = {
				view.activityIndicator.stopAnimating()
				view.activityIndicator.isHidden = true
				view.messageLabel.isHidden = true
				view.mainView.isHidden = false
			}

		case .empty:
			completion = {
				view.activityIndicator.stopAnimating()
				view.activityIndicator.isHidden = true
				view.messageLabel.isHidden = false
				view.messageLabel.text = "No data 🎁"
				view.mainView.isHidden = true
			}

		case .error:
			completion = {
				view.activityIndicator.startAnimating()
				view.activityIndicator.isHidden = true
				view.messageLabel.isHidden = false
				view.messageLabel.text = "Oops, something goes wrong 🤪"
				view.mainView.isHidden = true
			}
		}

		DispatchQueue.main.async(execute: completion)
	}
}
