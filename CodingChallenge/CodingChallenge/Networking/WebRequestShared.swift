//
//  WebRequestSetup.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import Foundation

class WebRequestShared: ApiUrls {
    func createUrlRequest(url: String, headers: [String: Any]?, httpMethod: HttpMethod, body: [String: Any]?) -> URLRequest? {
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
    
    func createDataFromDictionary(dict: [String: Any]) -> Data? {
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: .sortedKeys)
        } catch let error {
            print("Error getting data from dictionary; \(error.localizedDescription)")
        }
        return jsonData
    }
}
