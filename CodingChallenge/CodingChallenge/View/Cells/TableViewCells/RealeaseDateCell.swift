//
//  RealeaseDateCell.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ReleaseDateCell: UITableViewCell {
    
    @IBOutlet weak var anyText: UILabel!
    
    func configureCell(text: String, isTranscript: Bool) {
        anyText.text = isTranscript ? formatTranscript(transcript: text) : text
    }
    
    private func formatTranscript(transcript: String) -> String {
        
    }
    
}
