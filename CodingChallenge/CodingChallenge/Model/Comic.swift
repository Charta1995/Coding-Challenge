//
//  CurrentComic.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

public struct Comic: Decodable {
    var month: String
    var num: Int
    var link: String
    var year: String
    var news: String
    var safe_title: String
    var transcript: String
    var alt: String
    var img: String
    var title: String
    var day: String
    var imageData: Data?
    
    func getContentToShare(image: UIImage?, comicOnWeb: String, comicExplantaion: String) -> [Any] {
        var contentToShare = [Any]()
        contentToShare.append(image as Any)
      
        if alt != "" {
            contentToShare.append("\(alt)\n\n")
        }
        
        if transcript != "" {
            contentToShare.append("Transcript: \(transcript)\n\n")
        }
        
        contentToShare.append("Visit webpage: \(comicOnWeb)\n\n")
        contentToShare.append("Visit explanation: \(comicExplantaion)")
        
        return contentToShare
    }
    
    func createDictionaryForSaving(imageData: Data) -> [String: Any] {
        var dictionaryForSaving = [String: Any]()
        dictionaryForSaving["month"] = month
        dictionaryForSaving["num"] = num
        dictionaryForSaving["link"] = link
        dictionaryForSaving["year"] = year
        dictionaryForSaving["news"] = news
        dictionaryForSaving["safe_title"] = safe_title
        dictionaryForSaving["transcript"] = transcript
        dictionaryForSaving["alt"] = alt
        dictionaryForSaving["img"] = img
        dictionaryForSaving["title"] = title
        dictionaryForSaving["day"] = day
        dictionaryForSaving["imageData"] = imageData
        return dictionaryForSaving
    }
}
