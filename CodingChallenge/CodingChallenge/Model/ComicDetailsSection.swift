//
//  ComicDetailsSection.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

struct ComicDetailsSection {
    var contentDescription: String
    var content: [String]
    var isRedirectable: Bool
    
    init(contentDescription: String, content: [String], isRedirectable: Bool = false) {
        self.contentDescription = contentDescription
        self.content = content
        self.isRedirectable = isRedirectable
    }
}
