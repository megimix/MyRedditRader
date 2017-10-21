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
        case loading
        case loadingNext
    }
    
    var mode: PageMode = .loading {
        didSet {
            if self.mode != .loadingNext {
                self.didUpdate?(true)
            }
        }
    }
    
    let onlyFavorite: Bool
    var didError: UpdateHandler?
    var didUpdate: UpdateHandler?
    
    let numberOfSections = 1
    var numberOfItemsInSection: Int {
        return self.items().count
    }
    
    
    init(onlyFavorite: Bool, didUpdate: @escaping UpdateHandler, didError: @escaping UpdateHandler) {
        self.onlyFavorite = onlyFavorite
        self.didError = didError
        self.didUpdate = didUpdate
        
        ListingManager.sharedInstance.get { [unowned self] (result) in
            self.mode = .normal
        }
    }
    
    func items() -> [ListingModel] {
        let redditListing = ListingManager.sharedInstance.redditListing
        if self.onlyFavorite {
            return redditListing.items.filter({ (listModel) -> Bool in
                return listModel.isFavorite
            })
        }
        else {
            return redditListing.items
        }
    }
    
    func loadNextPage(with tableView: UITableView) {
        self.mode = .loadingNext
        ListingManager.sharedInstance.get { [unowned self] (result) in
            self.mode = .normal
            tableView.finishInfiniteScroll()
        }
    }
    
    func getCellIdentifier(for indexPath: IndexPath) -> String {
        return (String(describing: ReditListingCell.self))
    }
    
    func getCell(with tableView: UITableView, At indexPath: IndexPath) -> UITableViewCell {
        if let item = self.items()[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: self.getCellIdentifier(for: indexPath), for: indexPath) as? ReditListingCell {
                cell.titleLabel.text = item.title ?? ""
                cell.thumbnailImageView.sd_setImage(with: URL(string: item.thumbnailUrl!), placeholderImage: UIImage(named: "placeholder.png"))
            return cell
        }
        
        return UITableViewCell()
    }
}
