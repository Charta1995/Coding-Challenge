//
//  Protocols.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 30/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

/* Updates the favoriteViewController when coredata's table FavoriteComic has changed */
protocol UpdateFavoriteComicDelegate {
    func update(comics: [Comic])
}

/* Gives message to ComicDetailController when either add/delete from favorites or share button is tapped */
protocol OptionsButtonWasTapped {
    func deleteOrAddToFavoriteTapped(delete: Bool)
    func shareTapped()
}
