//
//  ComicSearch.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import Foundation

struct ComitSearch {
    var id: Int?
    var imageUrlEndpoint: String?
    
    init?(id: Int?, imageUrlEndpoint: String?) {
        self.id = id
        self.imageUrlEndpoint = imageUrlEndpoint
    }
}
