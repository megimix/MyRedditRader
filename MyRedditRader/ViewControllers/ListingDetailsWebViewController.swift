//
//  ListingDetailsWebViewController.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 21/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import UIKit
import WebKit

class ListingDetailsWebViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(URLRequest(url: URL(string: self.url)!))
    }
}
