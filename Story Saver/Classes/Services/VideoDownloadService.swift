//
//  VideoDownloadService.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit
import Alamofire
import Photos

protocol VideoDownloadServiceDelegate: class {
	func progressDidChanged(_ progress: CGFloat)
}

class VideoDownloadService {
	
	private let fileManager: FileManager
	
	weak var delegate: VideoDownloadServiceDelegate?
	
	init(fileManager: FileManager = FileManager.default) {
		self.fileManager = fileManager
	}
	
	func downloadAndSave(videoUrl: URL, completion: @escaping (Error?) -> Void) {
		let destination: (URL, HTTPURLResponse) -> (URL, DownloadRequest.DownloadOptions) = {
			tempUrl, response in
			
			let option = DownloadRequest.DownloadOptions()
			let finalUrl = tempUrl.deletingPathExtension().appendingPathExtension(videoUrl.pathExtension)
			return (finalUrl, option)
		}
		
		Alamofire.download(videoUrl, to: destination).responseData { (response) in
			guard response.error == nil,
				let destinationUrl = response.destinationURL else {
					completion(.unknown)
					return
			}
			self.save(videoFileUrl: destinationUrl, completion: completion)
		}.downloadProgress { (progress) in
			self.delegate?.progressDidChanged(CGFloat(progress.fractionCompleted))
		}
	}
	
	private func save(videoFileUrl: URL, completion: @escaping (Error?) -> Void) {
		PHPhotoLibrary.shared().performChanges({
			PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoFileUrl)
		}, completionHandler: { succeeded, error in
			guard error == nil, succeeded else {
				completion(.accessDenied)
				return
			}
			completion(nil)
		})
	}
}
