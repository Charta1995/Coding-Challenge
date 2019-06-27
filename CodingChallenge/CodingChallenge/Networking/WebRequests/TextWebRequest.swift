//
//  TextWebRequest.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import Foundation

class TextWebRequest: WebRequestShared {
    
    var request: URLSessionTask?
    
    func cancelRequest() {
        request?.cancel()
    }
    
    func makeTextWebRequest(url: String, headers: [String: Any]?, body: [String: Any]?, httpMethod: HttpMethod, finished: @escaping () -> ()) {
        if let urlRequest = createUrlRequest(url: url, headers: headers, httpMethod: httpMethod, body: body) {
            request = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if error == nil {
                    guard let data = data, let dataString = String(data: data, encoding: .utf8) else {
                        finished()
                        return
                    }
                    finished()
                } else {
                    finished()
                }
            }
            request?.resume()
        }
    }
}
