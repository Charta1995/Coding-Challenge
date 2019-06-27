//
//  CurrentComic.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

struct Comic: Decodable {
    var month: String
    var num: Int
    var link: String
    var year: String
    var news: String
    var save_title: String
    var transcript: String
    var alt: String
    var img: String
    var title: String
    var day: String
}
