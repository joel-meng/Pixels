//
//  UINavigationController+Completion.swift
//  CPixels
//
//  Created by Joel Meng on 8/2/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit

extension UINavigationController {

	func pushViewController(_ viewController: UIViewController,
							animated: Bool, completion: @escaping () -> Void) {

		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		pushViewController(viewController, animated: animated)
		CATransaction.commit()
	}

	func popViewController(_ animated: Bool, completion: @escaping () -> Void) {

		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		popViewController(animated: animated)
		CATransaction.commit()
	}
}
