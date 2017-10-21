//
//  RedditListingModel.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 21/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import Foundation

enum FilterMethods: String {
    case top
    case new
    
    func urlSafix() -> String {
        return self.rawValue + ".json"
    }
}

class RedditListingModel {
    var items: [ListingModel] = [ListingModel]()
    
    let channelName: String
    let filterMethod: FilterMethods
    
    init(channel name: String, filterMethod: FilterMethods) {
        self.channelName = name
        self.filterMethod = filterMethod
    }
}

class ListingModel {
    let id: String
    let title: String?
    let thumbnailUrl: String?
    let permalink: String?
    var isFavorite: Bool
    
    init?(with json: DictionaryStringAnyObject) {
        guard let data = json["data"] as? DictionaryStringAnyObject,
            let id = data["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.title = data["title"] as? String
        self.thumbnailUrl = data["thumbnail"] as? String
        self.permalink = data["permalink"] as? String
        self.isFavorite = false
    }
    
    static func parseArrayOfListModel(with json: DictionaryStringAnyObject) -> [ListingModel]? {
        guard let kind = json["kind"] as? String,
            kind == "Listing",
            let data = json["data"] as? [String : AnyObject],
            let dataChildren = data["children"] as?  [[String : AnyObject]] else {
                return nil
        }
        
        var arrayOfListModel = [ListingModel]()
        
        dataChildren.forEach { (obj) in
            if let aListingModel = ListingModel(with: obj) {
                arrayOfListModel.append(aListingModel)
            }
        }
        
        return arrayOfListModel.count > 0 ? arrayOfListModel : nil
    }
}
