//
//  Extensions.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension String {
    
    /**
     - Convert timestamp and both API keys to a 128-bit hash value for validation on Marvel API endpoint
     */
    var md5: String {
        
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
        
    }
    
}

extension UIImageView {
    
    /**
     - Check cache for image and retrieve from endpoint if not found. Then assign to UIImageView.
     - parameters:
        - link: String value of url for fetching image
     */
    func dowloadFromServer(link: String) {
        
        guard let url = URL(string: link) else { return }
        
        // Check cache for key which is the url of the image
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async() {
                self.image = cachedImage
                return
            }
        } else {
            // No image found in cache, so retrieve it from URL
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if (error != nil) {
                    return
                } else {
                    // Check data is valid and assign to UIImage
                    guard let data = data else { return }
                    guard let mimeType = response?.mimeType, mimeType.hasPrefix("image") else { return }
                    guard let image = UIImage(data: data) else { return }
                    
                    // Add new image to cache with URL as key
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    
                    DispatchQueue.main.async() {
                        self.image = image
                    }
                }
            }.resume()
        }
        
    }
    
}
