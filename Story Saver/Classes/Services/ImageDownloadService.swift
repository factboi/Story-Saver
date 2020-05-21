//
//  ImageDownloadService.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import Photos
import UIKit

enum Error: LocalizedError {
	case accessDenied
	case unknown
}

class ImageDownloadService {
	private init() {}
	static let shared = ImageDownloadService()
	func saveImage(_ imageUrl: URL, completion: @escaping (Error?) -> ()) {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
			guard let data = try? Data(contentsOf: imageUrl) else {
				DispatchQueue.main.async {
					completion(.unknown)
				}
				return
			}
			let image = UIImage(data: data)
			DispatchQueue.main.async {
				PHPhotoLibrary.requestAuthorization({ (status) in
					
					guard status == .authorized else {
						DispatchQueue.main.async {
							completion(.accessDenied)
						}
						return
					}
					
					PHPhotoLibrary.shared().performChanges({
						if let image = image {
							PHAssetChangeRequest.creationRequestForAsset(from: image)
						}
					}, completionHandler: { (saved, error) in
						DispatchQueue.main.async {
							if saved, error == nil {
								completion(nil)
							} else {
								completion(.unknown)
							}
						}
					})
				})
			}
		}
	}
}
