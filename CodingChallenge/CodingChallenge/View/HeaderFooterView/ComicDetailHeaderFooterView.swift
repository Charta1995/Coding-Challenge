//
//  ComicDetailHeaderFooterView.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicDetailHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var title: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureHeaderFooterView(text: String) {
        title.text = text
    }
}
