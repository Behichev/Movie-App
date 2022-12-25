//
//  CacheManager.swift
//  Movie App
//
//  Created by Ivan Behichev on 25.12.2022.
//

import UIKit

final class CacheManager {
    var imageCache: NSCache = NSCache<NSString, UIImage>()
    
    func dowlandImage(url: URL, complition: @escaping (UIImage?) -> Void ) {
        
        if let cahecdImage = imageCache.object(forKey: url.absoluteString as NSString) {
            complition(cahecdImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if error != nil {
                    if data != nil {
                        let response = response as? HTTPURLResponse
                        if response?.statusCode == 200 {
                            if let data {
                                guard let image = UIImage(data: data) else { return }
                                print(data)
                                self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                                
                                DispatchQueue.main.async {
                                    complition(image)
                                }
                            }
                            
                        }
                    } else {
                        print("No data")
                    }
                } else {
                    print("error?.localizedDescription")
                }
            }
            dataTask.resume()
        }
    }
}
