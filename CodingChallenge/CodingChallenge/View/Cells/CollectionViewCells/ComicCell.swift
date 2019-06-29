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
    
    private var comic: Comic?
    
    func configureCell(row: Int?, comic: Comic?) {
        setupLoader()
        loadComic(row: row, comic: comic)
    }
    
    func getCurrentComic() -> Comic? {
        return comic
    }
    
    private func loadComic(row: Int?, comic: Comic?) {
        var comicCompleteUrl: String!
        if let theRow = row {
            let comicNumber = theRow + 1
            comicCompleteUrl = "\(decodableWebRequest.spesificComicPartOne)\(comicNumber)\(decodableWebRequest.spesificComicPathTwo)"
            comicImage.contentMode = .scaleAspectFit
        } else {
            comicCompleteUrl = decodableWebRequest.current
        }
        
        if let coreDataComic = comic {
            updateComicAndCell(comic: coreDataComic, isComic: true)
        } else {
            if let theSavedComic = DataService.instance.getComic(url: comicCompleteUrl) {
                updateComicAndCell(comic: theSavedComic, isComic: false)
            } else {
                toggleLoading(shouldStart: true)
                decodableWebRequest.makeDecodableRequest(decodable: Comic.self, url: comicCompleteUrl, headers: nil, body: nil, httpMethod: .get) { (loadedComic) in
                    if let theLoadedComic = loadedComic {
                        DataService.instance.setComic(url: comicCompleteUrl, comic: theLoadedComic)
                        self.updateComicAndCell(comic: theLoadedComic, isComic: false)
                    }
                }
            }
        }
    }
    
    private func updateComicAndCell(comic: Comic, isComic: Bool) {
        self.comic = comic
        self.updateUI()
        self.loadComicImage(isComic: isComic)
    }
    
    private func loadComicImage(isComic: Bool) {
        if isComic {
            self.toggleLoading(shouldStart: true)
        }
        guard let comic = comic else { return }
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
        guard let comic = comic else { return }
        if comic.title != "" {
            comicTitle.text = comic.title
        } else {
            comicTitle.text = comic.safe_title
        }
    }
    
    private func updateCommicComment() {
        guard let comic = comic else { return }
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

