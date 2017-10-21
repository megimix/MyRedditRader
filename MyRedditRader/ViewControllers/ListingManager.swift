//
//  ListingManager.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 21/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import Foundation

class  ListingManager{
    static let sharedInstance = ListingManager()
    private init() {
        
    }
    
    let channelName = "Bitcoin"
    let filterMethod: FilterMethods = .top
    let baseUrl = "https://www.reddit.com/"
    let limit = "15"
    
    lazy var redditListing: RedditListingModel = {
       return RedditListingModel(channel: self.channelName, filterMethod: self.filterMethod)
    }()
    
    private func path() -> String {
        let path = self.baseUrl + "r/" + self.channelName + "/" + self.filterMethod.urlSafix() + "?count=" + self.limit
        var urlParams = ""
        if let item = self.redditListing.items.last {
            urlParams = "&after=" + item.id
        }
        return path + urlParams
    }
    
    func get(completion: @escaping(Result<RedditListingModel>) -> Void) {
        API.request(with: nil, to: self.path(), methodType: .GET) { (result) in
            switch result {
            case .success(let resultJson):
                if let arrayOfListModel = ListingModel.parseArrayOfListModel(with: resultJson) {
                    self.redditListing.items += arrayOfListModel
                    completion(Result.success(self.redditListing))
                }
            case .error(let error):
                completion(Result.error(e: error))
            }
        }
    }
    
    func urlForItem(at index: Int) -> String? {
        if let item = self.redditListing.items[safe: index],
            let permalink = item.permalink {
            return self.baseUrl + permalink
        }
        else {
            return nil
        }
    }
}
