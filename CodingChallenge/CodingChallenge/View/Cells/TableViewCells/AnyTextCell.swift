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
    
    func configureCell(text: String, isTranscript: Bool, isRedirectable: Bool) {
        self.selectionStyle = .none
        setupUI(text: text, isTranscript: isTranscript, isRedirectable: isRedirectable)
    }
    
    private func setupUI(text: String, isTranscript: Bool, isRedirectable: Bool) {
        setupRedirectCell(text: text, isRedirectable: isRedirectable)
        setupAnyText(text: text, isTranscript: isTranscript, isRedirectable: isRedirectable)
    }
    
    private func setupRedirectCell(text: String, isRedirectable: Bool) {
        redirectCell.isHidden = !isRedirectable
        redirectCell.textLabel?.text = text
    }
    
    private func setupAnyText(text: String, isTranscript: Bool, isRedirectable: Bool) {
        anyText.isHidden = isRedirectable
        anyText.text = isTranscript ? formatTranscript(transcript: text) : text
    }
    
    private func formatTranscript(transcript: String) -> String {
        return ""
    }
    
}
