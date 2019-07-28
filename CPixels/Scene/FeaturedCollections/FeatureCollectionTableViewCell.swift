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
import ReSwiftThunk

final class FeatureCollectionTableViewCell: UITableViewCell {

	@IBOutlet var coverPhotoImageView: UIImageView!

	@IBOutlet var collectionTitleLabel: UILabel!

	private var imageLoadingTask: URLSessionDataTaskProtocol?

	private var coverPhotoURL: String?

	func configure(with model: UnsplashCollection) {
		DispatchQueue.main.async { [weak self] in
			self?.collectionTitleLabel.text = model.title
		}

		if let coverPhotoURL = model.coverPhoto?.urls?.regular {

			self.coverPhotoURL = coverPhotoURL

			store.subscribe(self) { subscription in
				subscription.select({ (state) -> PhotoLoadingState in
					state.photoState
				})
			}

			// dispatch load photo
			store.dispatch(fetchImage(withURL: coverPhotoURL))
		}
	}

	override func prepareForReuse() {
		store.unsubscribe(self)

		imageLoadingTask?.cancel()
		imageLoadingTask = nil

		collectionTitleLabel.text = nil
		coverPhotoImageView.image = nil

		super.prepareForReuse()
	}
}

extension FeatureCollectionTableViewCell: StoreSubscriber {

	func newState(state: PhotoLoadingState) {
		if let coverPhotoURL = self.coverPhotoURL, let image = state.loaded[coverPhotoURL] {
			updateImage(image)
		}
	}

	private func updateImage(_ image: UIImage) {
		DispatchQueue.main.async {
			self.coverPhotoImageView.image = image
		}
	}
}

private func fetchImage(withURL imageUrl: String) -> Thunk<PixelsAppState> {

	return Thunk<PixelsAppState> { (dispatch, getState) in

		guard let state = getState() else { return }

		if let alreadyLoadedImage = state.photoState.loaded[imageUrl] {
			dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .success(alreadyLoadedImage)))
			return
		}

		dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .started))

		UnsplashService.loadImage(withURL: imageUrl, completion: { (result) in
			guard let loadedImage = try? result.get() else { return }
			dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .success(loadedImage)))
		})?.resume()
	}
}
