//
//  CoreDataComic.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import Foundation
import CoreData

@objc(FavoriteComic)
public class FavoriteComic: NSManagedObject {
    
    convenience init?(result: [String: Any], managedObjectContext: NSManagedObjectContext) {
        guard let month = result["month"] as? String, let num = result["num"] as? Int, let link = result["link"] as? String, let year = result["year"] as? String, let news = result["news"] as? String, let safe_title = result["safe_title"] as? String, let transcript = result["transcript"] as? String, let alt = result["alt"] as? String, let img = result["img"] as? String, let title = result["title"] as? String, let day = result["day"] as? String, let imageData = result["imageData"] as? Data else {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteComic", in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
        
        self.month = month
        self.num = Int32(num)
        self.link = link
        self.year = year
        self.news = news
        self.safe_title = safe_title
        self.transcript = transcript
        self.alt = alt
        self.img = img
        self.title = title
        self.day = day
        self.imageData = imageData
    }
    
    func convertToComic(instance: FavoriteComic) -> Comic? {
        guard let month = instance.month, let link = instance.link, let year = instance.year, let news = instance.news, let safe_title = instance.safe_title, let transcript = instance.transcript, let alt = instance.alt, let img = instance.img, let title = instance.title, let day = instance.day else {
            return nil
        }
        let comic = Comic(month: month, num: Int(instance.num), link: link, year: year, news: news, safe_title: safe_title, transcript: transcript, alt: alt, img: img, title: title, day: day)
        return comic
    }
    
}
