//
//  ImageLoader.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ImageLoader: WebRequestShared {
    
    var dataTask: URLSessionTask?
    
    func cancelRequest() {
        dataTask?.cancel()
    }
    
    /*
        This method is loading an image with given url, saves it to cache and returns it.
        If the same image has loaded once, the saved image will be used.
     */
    func loadImage(url: String, finishedLoadedImage: @escaping (_ loadedImage: UIImage?) -> ()) {
        if let savedImage = DataService.instance.getAnImage(url: url) {
            checkForMainThread {
                finishedLoadedImage(savedImage)
            }
        } else {
            guard let urlRequest = createUrlRequest(url: url, headers: nil, httpMethod: .get, body: nil) else {
                checkForMainThread {
                    finishedLoadedImage(nil)
                }
                return
            }
            dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
                if error == nil {
                    guard let data = data, let image = UIImage(data: data) else {
                        self.checkForMainThread {
                            finishedLoadedImage(nil)
                        }
                        return
                    }
                    DataService.instance.setimage(url: url, image: image)
                    self.checkForMainThread {
                        finishedLoadedImage(image)
                    }
                } else {
                    self.checkForMainThread {
                        finishedLoadedImage(nil)
                    }
                }
            })
            dataTask?.resume()
        }
    }
    
}
