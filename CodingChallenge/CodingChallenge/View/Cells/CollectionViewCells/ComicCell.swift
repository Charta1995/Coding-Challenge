//
//  ComicCell.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicCell: UICollectionViewCell {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicComment: UILabel!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let decodableWebRequest = DecodableWebRequest()
    let imageLoader = ImageLoader()
    
    private var comic: Comic!
    
    func configureCell(row: Int) {
        setupLoader()
        loadComic(row: row)
    }
    
    private func loadComic(row: Int) {
        let comicNumber = row + 1
        let comicCompleteUrl = "\(decodableWebRequest.spesificComicPartOne)\(comicNumber)\(decodableWebRequest.spesificComicPathTwo)"
        
        if let theSavedComic = DataService.instance.getComic(url: comicCompleteUrl) {
            updateComicAndCell(comic: theSavedComic)
        } else {
            toggleLoading(shouldStart: true)
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
                self.toggleLoading(shouldStart: false)
                self.updateImage(loadedImage: theLoadedComicImage)
            }
        }
    }
    
    private func updateUI() {
        updateTitle()
        updateCommicComment()
    }
    
    private func updateTitle() {
        if comic.title != "" {
            comicTitle.text = comic.title
        } else {
            comicTitle.text = comic.safe_title
        }
    }
    
    private func updateCommicComment() {
        if comic.alt == "" {
            self.comicComment.isHidden = true
        } else {
            self.comicComment.text = comic.alt
        }
    }
    
    private func updateImage(loadedImage: UIImage) {
        self.comicImage.image = loadedImage
    }
    
    private func toggleLoading(shouldStart: Bool) {
        loader.isHidden = !shouldStart
        if shouldStart {
            showOrHideUIElements(alpha: 0)
            loader.startAnimating()
        } else {
            loader.stopAnimating()
            UIView.animate(withDuration: 0.2) {
                self.showOrHideUIElements(alpha: 1)
            }
        }
    }
    
    private func showOrHideUIElements(alpha: CGFloat) {
        comicTitle.alpha = alpha
        comicImage.alpha = alpha
        comicComment.alpha = alpha
    }
    
    private func setupLoader() {
        loader.hidesWhenStopped = true
    }
}

