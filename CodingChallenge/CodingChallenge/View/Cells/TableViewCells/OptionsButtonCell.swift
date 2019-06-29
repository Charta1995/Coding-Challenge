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
    
    func configureCell(comicDetails: ComicDetails) {
        optionButtonWasTappedDelegate = comicDetails
        selectionStyle = .none
        configureAddToFavoritesBtn()
        confogireShareButton()
    }
    
    private func configureAddToFavoritesBtn() {
        addToFavoritesBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    private func confogireShareButton() {
        shareBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func addToFavorites(_ sender: UIButton!) {
        optionButtonWasTappedDelegate?.addToFavoriteTapped()
    }
    
    @IBAction func share(_ sender: UIButton!) {
        optionButtonWasTappedDelegate?.shareTapped()
    }
    
}
