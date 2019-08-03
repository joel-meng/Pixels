//
//  CollectionDetailsStoreSubscriber.swift
//  CPixels
//
//  Created by Joel Meng on 8/3/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

final class CollectionDetailsStoreSubscriber: StoreSubscriber {

	// MARK: - Collection related

	private var collection: UnsplashCollection? = nil

	private var collectionPhotoURLs: [String]? = nil

	// MARK: - Updater

	private var stateUpdater: ((ViewState<CollectionDetailsViewController>, [UIImage]?) -> Void)

	private var titleUpdater: ((String?) -> Void)

	// MARK: - Lifecycle

	init(stateUpdater: @escaping ((ViewState<CollectionDetailsViewController>, [UIImage]?) -> Void),
		 titleUpdater: @escaping (String?) -> Void) {
		self.stateUpdater = stateUpdater
		self.titleUpdater = titleUpdater
	}

	func newState(
		state: (selectedCollection: UnsplashCollection?,
		sceneState: CollectionPhotosSceneState,
		photoState: PhotoLoadingState)) {

		// Find user selected collection and fire `GetCollectionPhoto` API call
		if collection == nil, let selectedCollection = state.selectedCollection {
			collection = state.selectedCollection
			updaterUI(weaker: titleUpdater) { $0(state.selectedCollection?.title) }
			store.dispatch(fetchCollectionPhotos(collectionID: selectedCollection.id!, photosPerPage: 30))
			return
		}

		// Responding to `GetCollectionPhoto` API call
		if collectionPhotoURLs == nil {

			// If `GetCollectionPhoto` API call is `loading`, tell screen to `loading` state
			if case .loading = state.sceneState.collectionPhotos {
				updaterUI(weaker: stateUpdater) { $0(.loading, nil) }
				return
			}

			// If `GetCollectionPhoto` API call is `error`, tell screen to `error` state
			if case .error = state.sceneState.collectionPhotos {
				updaterUI(weaker: stateUpdater) { $0(.error, nil) }
				return
			}

			// If `GetCollectionPhoto` API call is `ready`
			if case let .ready(photos) = state.sceneState.collectionPhotos {

				// If `GetCollectionPhoto` is `empty`(no photos)
				guard !photos.isEmpty else {
					// Tell screen to display `empty`
					updaterUI(weaker: stateUpdater) { $0(.empty, nil) }
					return
				}

				// Save collection's photo thum urls
				collectionPhotoURLs = imageThumURLs(ofPhotos: photos)
			}
		}

		// At this point, `collectionPhotoURLs` should be collection's thum photo's urls
		guard let collectionPhotoURLs = collectionPhotoURLs else {
			return
		}

		// If thumb photos already cached, tell screen to load and display
		let loadedImage = imagesCached(forCollectionImageURLs: collectionPhotoURLs,
									   from: state.photoState.loaded)
		updaterUI(weaker: stateUpdater) { $0(.loaded, loadedImage) }

		// Download thumb photos that not cached.
		dispatchImageUncached(forCollectionImageURLs: collectionPhotoURLs,
							  from: state.photoState.loaded)
	}

	private func imageThumURLs(ofPhotos photos: [Photo]) -> [String] {
		return photos.compactMap { photo -> String? in
			photo.urls?.thumb
		}
	}

	private func imagesCached(forCollectionImageURLs collectionImageURLs: [String],
							  from imageCache: [String: UIImage]) -> [UIImage] {
		let loadedPhotoSet = Set(imageCache.keys)
		let collectionPhotoSet = Set(collectionImageURLs)
		let loadedCollectionPhotoSet = collectionPhotoSet.intersection(loadedPhotoSet)

		return Array(imageCache.filter { (url, image) -> Bool in
			loadedCollectionPhotoSet.contains(url)
		}.values)
	}

	private func dispatchImageUncached(forCollectionImageURLs collectionImageURLs: [String],
									   from imageCache: [String: UIImage]) {
		let loadedPhotoSet = Set(imageCache.keys)
		let collectionPhotoSet = Set(collectionImageURLs)
		collectionPhotoSet.subtracting(loadedPhotoSet).forEach({ (url) in
			store.dispatch(fetchImage(withURL: url))
		})
	}

	// MARK: - Subscription && Unsubscription

	func subscribePhotoStateSkippingRepeats() {

		store.subscribe(self) { subscription in
			subscription.select { state in

				let selectedCollection: UnsplashCollection? = state.navigationState.getRouteSpecificState(state.navigationState.route)
				let collectionPhotosSceneState = state.unsplashData.collectionPhotosScene

				let photoState = state.photoState

				return (selectedCollection, collectionPhotosSceneState, photoState)
			}
		}
	}

	func unsubscribePhotoState() {
		store.unsubscribe(self)
	}
}
