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
    
    func makeTextWebRequest(searchText: String, headers: [String: Any]?, body: [String: Any]?, httpMethod: HttpMethod, finished: @escaping (_ comicSearchResult: ComicSearchResult?) -> (), needToShowLoading: @escaping (_ needToShow: Bool) -> ()) {
        let completeUrl = "\(comicSeach)\(searchText)"
        if let savedSearchResult = DataService.instance.getComicSearchResult(url: completeUrl) {
            needToShowLoading(false)
            checkForMainThread {
                finished(savedSearchResult)
            }
        } else {
            needToShowLoading(true)
            if let urlRequest = createUrlRequest(url: completeUrl, headers: headers, httpMethod: httpMethod, body: body) {
                request = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                    if error == nil {
                        guard let data = data, let dataString = String(data: data, encoding: .utf8) else {
                            self.checkForMainThread {
                                finished(nil)
                            }
                            return
                        }
                        let comicSearchResult = self.parseDataString(dataString: dataString, completeUrl: completeUrl)
                        self.checkForMainThread {
                            finished(comicSearchResult)
                        }
                    } else {
                        self.checkForMainThread {
                            finished(nil)
                        }
                    }
                }
                
                request?.resume()
            }
        }
    }
    
    private func parseDataString(dataString: String, completeUrl: String) -> ComicSearchResult {
        let lines = dataString.split(separator: "\n")

        let relevance = String(lines[0])
        var comicSearchArray = [ComicSearch]()
        var index = 2
        while index < lines.count {
            let fractions = lines[index].split(separator: " ")
            var id: Int!
            var imageUrl: String!
            if fractions.count == 2 {
                id = Int(String(fractions[0]))
                imageUrl = String(fractions[1])
            }
            if let comicSearch = ComicSearch(id: id, imageUrlEndpoint: imageUrl, imageUrlStart: comicImageUrlStart) {
                comicSearchArray.append(comicSearch)
            }
            
            index += 2
        }
        
        let comicSearchResultRelevance = Double(relevance)
        let comicSearchResult = ComicSearchResult(relevance: comicSearchResultRelevance, comicSearches: comicSearchArray)
        DataService.instance.setComicSearchResult(url: completeUrl, comicSearchResult: comicSearchResult)
        return comicSearchResult
    }
}
