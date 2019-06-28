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
    
    func loadImage(url: String, finishedLoadedImage: @escaping (_ loadedImage: UIImage?) -> ()) {
        if let savedImage = DataService.instance.getAnImage(url: url) {
            finishedLoadedImage(savedImage)
        } else {
            guard let urlRequest = createUrlRequest(url: url, headers: nil, httpMethod: .get, body: nil) else {
                finishedLoadedImage(nil)
                return
            }
            dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
                if error == nil {
                    guard let data = data, let image = UIImage(data: data) else {
                        finishedLoadedImage(nil)
                        return
                    }
                    DataService.instance.setimage(url: url, image: image)
                    DispatchQueue.main.async {
                        finishedLoadedImage(image)
                    }
                } else {
                    finishedLoadedImage(nil)
                }
            })
            dataTask?.resume()
        }
    }
    
}
