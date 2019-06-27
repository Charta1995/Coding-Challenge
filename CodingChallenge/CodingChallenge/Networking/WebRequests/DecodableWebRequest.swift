//
//  DecodableWebRequest.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class DecodableWebRequest: ApiUrls {
    
    private var request: URLSessionTask?
    
    func cancelRequest() {
        request?.cancel()
    }
    
    func makeDecodableRequest<T>(decodable: T.Type, url: String, headers: [String: Any]?, body: [String: Any], httpMethod: HttpMethod, finished: @escaping (_ decodable: T?) -> ()) where T: Decodable {
        
        if let urlRequest = createUrlRequest(url: url, headers: headers, httpMethod: httpMethod, body: body) {
            request = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                var decodableObject: T?
                
                if error == nil {
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        finished(decodableObject)
                        return
                    }
                    
                    if (response.statusCode != 200) {
                        finished(decodableObject)
                        return
                    }
                    
                    do {
                        decodableObject = try JSONDecoder().decode(decodable, from: data)
                        finished(decodableObject)
                    } catch let error {
                        print("Error parsing data to decodable object: \(error.localizedDescription)")
                        finished(decodableObject)
                    }
                } else {
                    finished(decodableObject)
                }
            }
            request?.resume()
        }
        
    }
    
    private func createUrlRequest(url: String, headers: [String: Any]?, httpMethod: HttpMethod, body: [String: Any]?) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        if let headers = headers {
            for dictObj in headers {
                urlRequest.setValue("\(dictObj.value)", forHTTPHeaderField: "\(dictObj.key)")
            }
        }
        
        if let body = body, let bodyData = createDataFromDictionary(dict: body) {
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
    
    private func createDataFromDictionary(dict: [String: Any]) -> Data? {
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: .sortedKeys)
        } catch let error {
            print("Error getting data from dictionary; \(error.localizedDescription)")
        }
        return jsonData
    }
    
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
