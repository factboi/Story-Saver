//
//  Extension.swift
//  Story Saver
//
//  Created by factboi on 21.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import AVKit
extension UIImage {
	func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
		DispatchQueue.global().async { //1
			let asset = AVAsset(url: url) //2
			let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
			avAssetImageGenerator.appliesPreferredTrackTransform = true //4
			let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
			do {
				let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
				let thumbImage = UIImage(cgImage: cgThumbImage) //7
				DispatchQueue.main.async { //8
					completion(thumbImage) //9
				}
			} catch {
				DispatchQueue.main.async {
					completion(nil) //11
				}
			}
		}
	}	
}
