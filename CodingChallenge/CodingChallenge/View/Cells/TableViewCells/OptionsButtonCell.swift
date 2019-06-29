//
//  OptionsButtonCell.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class OptionsButtonCell: UITableViewCell {
    
    @IBOutlet weak var addToFavoritesBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    private var optionButtonWasTappedDelegate: OptionsButtonWasTapped?
    private var isFavorite: Bool!
    
    func configureCell(comicDetails: ComicDetails, isFavorite: Bool) {
        optionButtonWasTappedDelegate = comicDetails
        self.isFavorite = isFavorite
        selectionStyle = .none
        configureAddToFavoritesBtn()
        confogireShareButton()
    }
    
    private func configureAddToFavoritesBtn() {
        addToFavoritesBtn.imageView?.contentMode = .scaleAspectFit
        setImageAndTitleToFavoritesBtn(clicked: false, isFavorite: isFavorite)
    }
    
    private func confogireShareButton() {
        shareBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setImageAndTitleToFavoritesBtn(clicked: Bool, isFavorite: Bool) {
        var imageToSet: UIImage!
        var titleToSet: String!
        if clicked {
            imageToSet = isFavorite ? UIImage(named: "icon")! : UIImage(named: "star")!
            titleToSet = isFavorite ? "Add to favorites" : "Remove from favorites"
        } else {
            imageToSet = isFavorite ? UIImage(named: "star") : UIImage(named: "icon")
            titleToSet = isFavorite ? "Remove from favorites" : "Add to favorites"
        }
        addToFavoritesBtn.setImage(imageToSet, for: .normal)
        addToFavoritesBtn.setTitle(titleToSet, for: .normal)
    }
    
    @IBAction func addToFavorites(_ sender: UIButton!) {
        optionButtonWasTappedDelegate?.deleteOrAddToFavoriteTapped(delete: isFavorite)
        setImageAndTitleToFavoritesBtn(clicked: true, isFavorite: isFavorite)
    }
    
    @IBAction func share(_ sender: UIButton!) {
        optionButtonWasTappedDelegate?.shareTapped()
    }
    
}
