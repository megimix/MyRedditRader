//
//  ListingViewModel.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 20/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import UIKit

class RedditListingModel {
    var items: [ListingModel]
    
    init(items: [ListingModel]) {
        self.items = items
    }
}

class ListingModel {
    let id: String
    
    init?(with json: [String : Any]) {
        guard let id = json["id"] as? String else {
            return nil
        }
        
        self.id = id
    }
}

typealias UpdateHandler = (_ animated: Bool) -> ()

class ReditListingCell: UITableViewCell{
    
}

class ListingViewModel {
    enum PageMode {
        case normal
        case waitingForLogin
        case loading
    }
    
    var redditListing: RedditListingModel?
    
    var mode: PageMode = .normal {
        didSet {
            self.didUpdate?(true)
        }
    }
    
    let numberOfSections = 1;
    var numberOfItemsInSection: Int {
        return (self.redditListing?.items.count) ?? 0
    }
    
    var didError: UpdateHandler?
    var didUpdate: UpdateHandler?
    
    init(didUpdate: @escaping UpdateHandler, didError: @escaping UpdateHandler) {
        self.didError = didError
        self.didUpdate = didUpdate
        
        if let item1 = ListingModel(with: ["id": "11111"]),
            let item2 = ListingModel(with: ["id": "2222"]),
            let item3 = ListingModel(with: ["id": "3333"]){
            let redditListingModel = RedditListingModel(items: [item1, item2, item3])
            self.redditListing = redditListingModel
        }
    }
    
    func getCellIdentifier(for indexPath: IndexPath) -> String {
        return (String(describing: ReditListingCell.self))
    }
    
    func getCell(with tableView: UITableView, At indexPath: IndexPath) -> UITableViewCell {
        if let item = self.redditListing?.items[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: self.getCellIdentifier(for: indexPath), for: indexPath) as? ReditListingCell {
            cell.textLabel?.text = item.id
            
            return cell
        }
        
        return UITableViewCell()
    }
}
