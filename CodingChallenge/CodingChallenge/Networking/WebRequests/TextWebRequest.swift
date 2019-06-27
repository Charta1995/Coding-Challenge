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
    
    func makeTextWebRequest(url: String, headers: [String: Any]?, body: [String: Any]?, httpMethod: HttpMethod, finished: @escaping (_ comicSearchResult: ComicSearchResult?) -> ()) {
        if let urlRequest = createUrlRequest(url: url, headers: headers, httpMethod: httpMethod, body: body) {
            request = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if error == nil {
                    guard let data = data, let dataString = String(data: data, encoding: .utf8) else {
                        finished(nil)
                        return
                    }
                    let comicSearchResult = self.parseDataString(dataString: dataString)
                    finished(comicSearchResult)
                } else {
                    finished(nil)
                }
            }
            request?.resume()
        }
    }
    
    private func parseDataString(dataString: String) -> ComicSearchResult {
        let fractions = dataString.split(separator: " ")
        
        let relevance = String(fractions[0])
        var comicSearchArray = [ComicSearch]()
        var index = 2
        while index < fractions.count {
            
            let comicIdString = String(fractions[index])
            let comicId = Int(comicIdString)
            let imageUrlEndpoint = String(fractions[index])
            
            if let comicSearch = ComicSearch(id: comicId, imageUrlEndpoint: imageUrlEndpoint, imageUrlStart: comicImageUrlStart) {
                comicSearchArray.append(comicSearch)
            }
            
            index += 1
        }
        
        let comicSearchResultRelevance = Double(relevance)
        let comicSearchResult = ComicSearchResult(relevance: comicSearchResultRelevance, comicSearches: comicSearchArray)
        
        return comicSearchResult
    }
}
