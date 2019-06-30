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
    
    func configureCell(row: Int?, comic: Comic?, searchRow: Int?) {
        setupLoader()
        loadComic(row: row, comic: comic, searchRow: searchRow)
    }
    
    func getCurrentComic() -> Comic? {
        return comic
    }
    
    /*
        This method is responsibly for loading comics and update the UI.
     */
    private func loadComic(row: Int?, comic: Comic?, searchRow: Int?) {
        //Setting the image to nil to display the correct image at once
        comicImage.image = nil
        var comicCompleteUrl: String!
        /* Figuring out the correct url */
        if let theRow = row {
            let comicNumber = theRow + 1
            comicCompleteUrl = "\(decodableWebRequest.spesificComicPartOne)\(comicNumber)\(decodableWebRequest.spesificComicPathTwo)"
            comicImage.contentMode = .scaleAspectFit
        } else {
            if let theSearchRow = searchRow {
                comicCompleteUrl = "\(decodableWebRequest.spesificComicPartOne)/\(theSearchRow)/\(decodableWebRequest.spesificComicPathTwo)"
            } else {
                comicCompleteUrl = decodableWebRequest.current
            }
        }
        
        //If the comic is already saved either in coredata or in cache, the UI will be updated at once.
        if let coreDataComic = comic {
            updateComicAndCell(comic: coreDataComic, isComic: true)
        } else {
            if let theSavedComic = DataService.instance.getComic(url: comicCompleteUrl) {
                updateComicAndCell(comic: theSavedComic, isComic: false)
            } else {
                //Showing activity indicator.
                toggleLoading(shouldStart: true)
                //Starting to load.
                decodableWebRequest.makeDecodableRequest(decodable: Comic.self, url: comicCompleteUrl, headers: nil, body: nil, httpMethod: .get) { (loadedComic) in
                    if let theLoadedComic = loadedComic {
                        DataService.instance.setComic(url: comicCompleteUrl, comic: theLoadedComic)
                        self.updateComicAndCell(comic: theLoadedComic, isComic: false)
                    }
                }
            }
        }
    }
    
    //Updating the whole UI
    private func updateComicAndCell(comic: Comic, isComic: Bool) {
        self.comic = comic
        self.updateUI()
        self.loadComicImage(isComic: isComic, imageData: comic.imageData)
    }
    
    //This method is responsible for loading the image, either from a cache/coredata or online. The cache and coredata is prioritized.
    private func loadComicImage(isComic: Bool, imageData: Data?) {
        //Update the UI at once when the comic is coming from coredata.
        if isComic {
            if let imageData = imageData {
                if let savedImage = UIImage(data: imageData) {
                    self.updateImage(loadedImage: savedImage)
                    return
                }
            }
        }
        //The image has to be loaded from either online or cache.
        //Starting activity indicator
        self.toggleLoading(shouldStart: true)
        guard let comic = comic else { return }
        //Loading image from either cacne or online, the cache are prioritized.
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

