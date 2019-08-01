//
//  FeaturedCollectionTableViewCell.swift
//  CPixels
//
//  Created by Joel Meng on 7/28/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import ReSwiftThunk

final class UnsplashCollectionTableViewCell: ReflexTableViewCell<UnsplashCollection> {

	@IBOutlet var titleOnlyView: UIView!
	@IBOutlet var titleOnlyLabel: UILabel!

	@IBOutlet var imagedTitleView: UIView!
	@IBOutlet var imageAndTitleLabel: UILabel!
	@IBOutlet var imageTitleImageView: UIImageView!

	private var imageLoadingTask: URLSessionDataTaskProtocol?

	private var coverPhotoURL: String?

	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		imagedTitleView.layer.cornerRadius = 6
		imagedTitleView.clipsToBounds = true
	}

	override func config(_ item: UnsplashCollection) {

		configTitleOnlyMode(withTitle: item.title)

		if let coverPhotoURL = item.coverPhoto?.urls?.small {

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

		configTitleOnlyMode(withTitle: nil)

		imageLoadingTask?.cancel()
		imageLoadingTask = nil

		super.prepareForReuse()
	}

	private func configTitleOnlyMode(withTitle title: String?) {
		titleOnlyLabel.text = title
		imageAndTitleLabel.text = title

		imagedTitleView.isHidden = true
		titleOnlyView.isHidden = false
	}

	private func configTitleAndImageMode(withImage image: UIImage) {
		imageTitleImageView.image = image

		imagedTitleView.isHidden = false
		titleOnlyView.isHidden = true
	}
}

extension UnsplashCollectionTableViewCell: StoreSubscriber {

	func newState(state: PhotoLoadingState) {
		if let coverPhotoURL = self.coverPhotoURL, let image = state.loaded[coverPhotoURL] {
			updateImage(image)
		}
		print("photo count: \(state.loaded.count)")
	}

	private func updateImage(_ image: UIImage) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.configTitleAndImageMode(withImage: image)
			store.unsubscribe(self)
		}
	}
}
