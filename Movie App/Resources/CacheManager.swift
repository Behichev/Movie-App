//
//  CacheManager.swift
//  Movie App
//
//  Created by Ivan Behichev on 25.12.2022.
//

import UIKit

final class CacheManager {
    var imageCache: NSCache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: URL, complition: @escaping (UIImage?) -> Void ) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            complition(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                      data != nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                       let self = self else {
                    return
                }
                guard let data else { return }
                guard let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    complition(image)
                }
            }
            dataTask.resume()
        }
    }
}
