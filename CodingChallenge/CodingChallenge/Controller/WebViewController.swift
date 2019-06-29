//
//  WebViewController.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String!
    private let webRequestShared = WebRequestShared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Web"
        loadUrl()
    }
    
    private func loadUrl() {
        if let theUrlRequest = webRequestShared.createUrlRequest(url: url, headers: nil, httpMethod: .get, body: nil) {
            webView.load(theUrlRequest)
        }
    }
    
}
