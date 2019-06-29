//
//  RealeaseDateCell.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class AnyTextCell: UITableViewCell {
    
    @IBOutlet weak var anyText: UILabel!
    @IBOutlet weak var redirectCell: UITableViewCell!
    
    func configureCell(text: String, isRedirectable: Bool) {
        selectionStyle = .none
        setupUI(text: text, isRedirectable: isRedirectable)
    }
    
    private func setupUI(text: String, isRedirectable: Bool) {
        setupRedirectCell(text: text, isRedirectable: isRedirectable)
        setupAnyText(text: text, isRedirectable: isRedirectable)
    }
    
    private func setupRedirectCell(text: String, isRedirectable: Bool) {
        redirectCell.isHidden = !isRedirectable
        redirectCell.textLabel?.text = text
    }
    
    private func setupAnyText(text: String, isRedirectable: Bool) {
        anyText.isHidden = isRedirectable
        anyText.text = text
    }
    
}
