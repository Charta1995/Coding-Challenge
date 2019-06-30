//
//  DataService.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class DataService {
    
    static let instance = DataService()
    
    /*
        Nib ids
     */
    let comicNibId = "comicCellNibID"
    
    let anyTextNibId = "anyTextID"
    let optionButtonsNibId = "optionsButtonCellID"
    let headerFooterViewNib = "comicDetailHeaderFooterView"
    
    /*
        Segue ids
     */
    let segueToComicDetail = "toComicDesc"
    let segueToVisitComicWebsite = "goToWebController"
    
    
    
    /*
        I'm using chaches for saving what has been loaded, to then reuse it later.
     */
    
    fileprivate let imageCache: NSCache<NSString, UIImage> = NSCache()
    fileprivate var comicCache = [String: Comic]() // NSCache<NSString, ComicContainer> = NSCache()
    fileprivate var comicSearchResultCache = [String: [ComicSearch]]() //NSCache<NSString, ComicSearchResultContainer> = NSCache()
    
    /*
        Temporarely save an image.
     */
    
    func setimage(url: String, image: UIImage) {
        imageCache.setObject(image, forKey: url as NSString)
    }
    
    
    /*
        Get an image that is temporarely saved
     */
    func getAnImage(url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
    
    /*
        Temporarely save a comic.
        I'm using a container class because NSCache doenst support struct.
        I'm using a struct for the comic because struct is faster than classes and i'm using the new json fetching with the protocol, Decodable.
     */
    func setComic(url: String, comic: Comic) {
        comicCache[url] = comic //.setObject(ComicContainer(comic: comic), forKey: url as NSString)
    }
    
    /*
        Get a comic which is temporarely saved
    */
    func getComic(url: String) -> Comic? {
        return comicCache[url] //.object(forKey: url as NSString)?.comic
    }
    
    /*
        Temporarely save a comic search result.
     */
    
    func setComicSearchResult(url: String, comicSearchResult: [ComicSearch]) {
        comicSearchResultCache[url] = comicSearchResult // .setObject(ComicSearchResultContainer(comicSearchResult: comicSearchResult), forKey: url as NSString)
    }
    
    /*
        Get a temporarely saved comic search result.
     */
    func getComicSearchResult(url: String) -> [ComicSearch]? {
        return comicSearchResultCache[url] // .object(forKey: url as NSString)?.comicSearchResult
    }
    
}
