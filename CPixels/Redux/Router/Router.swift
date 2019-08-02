//
//  Router.swift
//  CPixels
//
//  Created by Joel Meng on 8/1/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import ReSwiftRouter
import UIKit

let mainViewRoute: RouteElementIdentifier = "Main"
let photosViewRoute: RouteElementIdentifier = "Photos"


final class RootRoutable: Routable {

	let window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	func setToMainViewController() -> Routable {
		let featuredCollectionsViewController = FeaturedCollectionViewController(nibName: "FeaturedCollectionViewController",
																				 bundle: nil)
		let rootViewController = UINavigationController(rootViewController: featuredCollectionsViewController)
		self.window.rootViewController = rootViewController
		return MainViewRoutable(self.window.rootViewController!)
	}

	func changeRouteSegment(_ from: RouteElementIdentifier,
							to: RouteElementIdentifier,
							animated: Bool,
							completionHandler: @escaping RoutingCompletionHandler) -> Routable {

		if to == mainViewRoute {
			completionHandler()
			return setToMainViewController()
		}

		fatalError("Route not supported!")
	}

	func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
						  animated: Bool,
						  completionHandler: @escaping RoutingCompletionHandler) -> Routable {

		if routeElementIdentifier == mainViewRoute {
			completionHandler()
			return setToMainViewController()
		}
		fatalError("Route not supported!")
	}

	func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
						 animated: Bool,
						 completionHandler: @escaping RoutingCompletionHandler) {
		completionHandler()
	}
}

final class MainViewRoutable: Routable {

	let mainViewController: UIViewController

	init(_ mainViewController: UIViewController) {
		self.mainViewController = mainViewController
	}

	public func changeRouteSegment(_ from: RouteElementIdentifier,
								   to: RouteElementIdentifier,
								   animated: Bool,
								   completionHandler: @escaping RoutingCompletionHandler) -> Routable {
		if to == photosViewRoute {
			let detailsViewController = CollectionDetailsViewController(nibName: "CollectionDetailsViewController",
																		bundle: nil)
			mainViewController.show(detailsViewController, sender: self)
			completionHandler()
			return PhotosViewRoutable(detailsViewController)
		}
		fatalError("Route not supported!")
	}

	public func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
								 animated: Bool,
								 completionHandler: @escaping RoutingCompletionHandler) -> Routable {
		if routeElementIdentifier == photosViewRoute {
			let detailsViewController = CollectionDetailsViewController(nibName: "CollectionDetailsViewController",
																		bundle: nil)
			mainViewController.show(detailsViewController, sender: self)
			completionHandler()
			return PhotosViewRoutable(detailsViewController)
		}
		fatalError("Route not supported!")
	}

	public func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
								animated: Bool,
								completionHandler: @escaping RoutingCompletionHandler) {
		completionHandler()
	}
}

final class PhotosViewRoutable: Routable {

	let mainViewController: UIViewController

	init(_ mainViewController: UIViewController) {
		self.mainViewController = mainViewController
	}
}
