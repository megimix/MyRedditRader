//
//  ListingViewModel.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 20/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import UIKit
import SDWebImage

typealias UpdateHandler = (_ animated: Bool) -> ()

class ListingViewModel {
    enum PageMode {
        case normal
//        case waitingForLogin
        case loading
        case loadingNext
    }
    
    let redditListing: RedditListingModel
    
    var mode: PageMode = .loading {
        didSet {
            if self.mode != .loadingNext {
                self.didUpdate?(true)
            }
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
    
    func loadNextPage(with tableView: UITableView) {
        self.mode = .loadingNext
        self.redditListing.get { (result) in
            self.mode = .normal
            tableView.finishInfiniteScroll()
        }
    }
    
    func getCellIdentifier(for indexPath: IndexPath) -> String {
        return (String(describing: ReditListingCell.self))
    }
    
    func getCell(with tableView: UITableView, At indexPath: IndexPath) -> UITableViewCell {
        if let item = self.redditListing.items[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: self.getCellIdentifier(for: indexPath), for: indexPath) as? ReditListingCell {
                cell.titleLabel.text = item.title ?? ""
                cell.thumbnailImageView.sd_setImage(with: URL(string: item.thumbnailUrl!), placeholderImage: UIImage(named: "placeholder.png"))
            return cell
        }
        
        return UITableViewCell()
    }
}
