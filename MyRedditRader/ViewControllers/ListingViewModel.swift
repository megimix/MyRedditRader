//
//  ListingViewModel.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 20/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import UIKit

typealias UpdateHandler = (_ animated: Bool) -> ()

class ReditListingCell: UITableViewCell{
    
}

class ListingViewModel {
    enum PageMode {
        case normal
//        case waitingForLogin
        case loading
    }
    
    let redditListing: RedditListingModel
    
    var mode: PageMode = .loading {
        didSet {
            self.didUpdate?(true)
        }
    }
    
    let numberOfSections = 1
    var numberOfItemsInSection: Int {
        return self.redditListing.items.count
    }
    
    var didError: UpdateHandler?
    var didUpdate: UpdateHandler?
    
    init(channelName: String, didUpdate: @escaping UpdateHandler, didError: @escaping UpdateHandler) {
        self.didError = didError
        self.didUpdate = didUpdate
        
        self.redditListing = RedditListingModel(channel: channelName, filterMethod: .top)
        self.redditListing.get { (result) in
            self.mode = .normal
        }
    }
    
    func getCellIdentifier(for indexPath: IndexPath) -> String {
        return (String(describing: ReditListingCell.self))
    }
    
    func getCell(with tableView: UITableView, At indexPath: IndexPath) -> UITableViewCell {
        if let item = self.redditListing.items[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: self.getCellIdentifier(for: indexPath), for: indexPath) as? ReditListingCell {
            cell.textLabel?.text = item.id
            
            return cell
        }
        
        return UITableViewCell()
    }
}
