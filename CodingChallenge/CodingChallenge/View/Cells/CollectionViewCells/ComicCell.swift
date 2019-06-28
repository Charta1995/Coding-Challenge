//
//  ComicCell.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imageZoomScrollView: UIScrollView!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var title: UILabel!
    
    private let decodableWebRequest = DecodableWebRequest()
    
    func configureCell(row: Int) {
        
    }
    
    private func loadComic(row: Int) {
        
    }
    
    private func loadComicImage() {
        
    }
    
}
