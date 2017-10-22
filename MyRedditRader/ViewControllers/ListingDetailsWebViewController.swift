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
    let htmlErrorMassge = "<br/><h2>somthing went wronge</h2>"
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            self.webView.navigationDelegate = self
        }
    }
    
    @IBOutlet var loadSpinner: UIActivityIndicatorView!
    var listingModel: ListingModel?
    var showRemoveFromFavorite: Bool = false
    
    override func viewDidLoad() {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        if let listingUrl = self.listingModel?.permalink,
            let url = URL(string: ListingManager.sharedInstance.baseUrl + listingUrl) {
            self.webView.load(URLRequest(url: url))
        }
        else {
            self.webView.loadHTMLString(self.htmlErrorMassge, baseURL: nil)
        }
        
        self.updateRightBarButtonItem(showRemoveFromFavorite: self.showRemoveFromFavorite)
    }
    
    func updateRightBarButtonItem(showRemoveFromFavorite: Bool) {
        let rightBarButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:(showRemoveFromFavorite ? .trash : .add), target: self, action: #selector(rightBarButtonItemPressed))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func rightBarButtonItemPressed() {
        if let listingModel = self.listingModel {
            listingModel.isFavorite = !listingModel.isFavorite
            self.updateRightBarButtonItem(showRemoveFromFavorite: listingModel.isFavorite)
        }
    }
}


extension ListingDetailsWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadSpinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadSpinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadSpinner.stopAnimating()
    }
}
