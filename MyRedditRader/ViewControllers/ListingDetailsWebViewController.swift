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
    @IBOutlet var loadSpinner: UIActivityIndicatorView!
    var listingModel: ListingModel?
    var showRemoveFromFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let listingUrl = self.listingModel?.permalink,
            let url = URL(string: ListingManager.sharedInstance.baseUrl + listingUrl) {
            self.webView.load(URLRequest(url: url))
        }
        else {
            //present somting went wrong.
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
    
    func webViewDidStartLoad(_ : UIWebView) {
        self.loadSpinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        self.loadSpinner.stopAnimating()
    }
}
