//
//  FeatureCollectionTableViewCell.swift
//  CPixels
//
//  Created by Joel Meng on 7/28/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

final class FeatureCollectionTableViewCell: UITableViewCell {

	@IBOutlet var coverPhotoImageView: UIImageView!

	@IBOutlet var collectionTitleLabel: UILabel!

	private var imageLoadingTask: URLSessionDataTaskProtocol?

	func configure(with model: UnsplashCollection) {
		collectionTitleLabel.text = model.title

		if let coverPhoto = model.coverPhoto?.urls?.regular {

			store.subscribe(self) { subscription in
				subscription.select({ (state) -> PhotoLoadingState in
					state.photoState
				}).skipRepeats()
			}

			// dispatch load photo
			imageLoadingTask = UnsplashService.loadImage(withURL: coverPhoto, completion: { [weak self] (result) in
				guard let loadedImage = try? result.get() else { return }
				DispatchQueue.main.async {
					self?.coverPhotoImageView.image = loadedImage
				}
			})
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		store.unsubscribe(self)
	}

}

extension FeatureCollectionTableViewCell: StoreSubscriber {

	func newState(state: PhotoLoadingState) {

	}

	private func updateImage(_ image: UIImage) {

	}
}
