//
//  DecodableWebRequest.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class DecodableWebRequest: WebRequestShared {
    
    private var request: URLSessionTask?
    
    func cancelRequest() {
        request?.cancel()
    }
    
    /*
        This method is making a urlrequest and are returning a generic of decodable.
     */
    func makeDecodableRequest<T>(decodable: T.Type, url: String, headers: [String: Any]?, body: [String: Any]?, httpMethod: HttpMethod, finished: @escaping (_ decodable: T?) -> ()) where T: Decodable {
        
        if let urlRequest = createUrlRequest(url: url, headers: headers, httpMethod: httpMethod, body: body) {
            request = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                var decodableObject: T?
                
                if error == nil {
                    guard let data = data else {
                        self.checkForMainThread {
                            finished(decodableObject)
                        }
                        return
                    }
                    
                    do {
                        decodableObject = try JSONDecoder().decode(decodable, from: data)
                        self.checkForMainThread {
                            finished(decodableObject)
                        }
                    } catch let error {
                        print("Error parsing data to decodable object: \(error)")
                        self.checkForMainThread {
                            finished(decodableObject)
                        }
                    }
                } else {
                    self.checkForMainThread {
                        finished(decodableObject)
                    }
                }
            }
            request?.resume()
        }
        
    }
}
