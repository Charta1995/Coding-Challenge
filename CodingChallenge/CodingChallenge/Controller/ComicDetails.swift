//
//  ComicDetails.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicDetails: UIViewController {
    
    @IBOutlet weak var detailInfoTable: UITableView!
    @IBOutlet weak var imageZoomScrollVie: UIScrollView!
    @IBOutlet weak var comicImage: UIImageView!
    
    var selectedComic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        detailInfoTable.dataSource = self
        detailInfoTable.estimatedRowHeight = 100
        detailInfoTable.rowHeight = UITableView.automaticDimension
    }
    
}

extension ComicDetails: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
