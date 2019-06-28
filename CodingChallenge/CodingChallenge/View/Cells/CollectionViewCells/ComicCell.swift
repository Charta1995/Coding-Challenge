//
//  ComicCell.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicCell: UICollectionViewCell {
    
    @IBOutlet weak var imageZoomScrollView: UIScrollView!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var title: UILabel!
    
    let decodableWebRequest = DecodableWebRequest()
    let imageLoader = ImageLoader()
    
    private var comic: Comic!
    
    func configureCell(row: Int) {
        loadComic(row: row)
    }
    
    private func loadComic(row: Int) {
        let comicNumber = row + 1
        let comicCompleteUrl = "\(decodableWebRequest.spesificComicPartOne)\(comicNumber)\(decodableWebRequest.spesificComicPathTwo)"
        
        if let theSavedComic = DataService.instance.getComic(url: comicCompleteUrl) {
            updateComicAndCell(comic: theSavedComic)
        } else {
            decodableWebRequest.makeDecodableRequest(decodable: Comic.self, url: comicCompleteUrl, headers: nil, body: nil, httpMethod: .get) { (loadedComic) in
                if let theLoadedComic = loadedComic {
                    DataService.instance.setComic(url: comicCompleteUrl, comic: theLoadedComic)
                    self.updateComicAndCell(comic: theLoadedComic)
                }
            }
        }
    }
    
    private func updateComicAndCell(comic: Comic) {
        self.comic = comic
        self.updateUI()
        self.loadComicImage()
    }
    
    private func loadComicImage() {
        imageLoader.loadImage(url: comic.img) { (loadedComicImage) in
            if let theLoadedComicImage = loadedComicImage {
                self.updateImage(loadedImage: theLoadedComicImage)
            }
        }
    }
    
    private func updateUI() {
        updateTitle()
        updatePublisDate()
    }
    
    private func updateTitle() {
        if comic.title != "" {
            self.title.text = comic.title
        } else if comic.save_title != "" {
            self.title.text = comic.save_title
        } else {
            self.title.text = comic.alt
        }
    }
    
    private func updatePublisDate() {
        self.publishDate.text = "\(comic.day)/\(comic.month)/\(comic.year)"
    }
    
    private func updateImage(loadedImage: UIImage) {
        self.comicImage.image = loadedImage
    }
    
    
}
