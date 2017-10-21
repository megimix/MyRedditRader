//
//  RedditListingModel.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 21/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import Foundation

class RedditListingModel {
    enum FilterMethods: String {
        case top
        case new
        
        func urlString() -> String {
            return self.rawValue + ".json"
        }
    }
    var items: [ListingModel] = [ListingModel]()
    let channelName: String
    let filterMethod: FilterMethods
    let baseUrl = "https://www.reddit.com/r/"
    let limit = "15"
    
    init(channel name: String, filterMethod: FilterMethods) {
        self.channelName = name
        self.filterMethod = filterMethod
    }
    
    func path() -> String {
        let path = self.baseUrl + self.channelName + "/" + self.filterMethod.urlString() + "?count=" + self.limit
        var urlParams = ""
        if let item = self.items.last {
            urlParams = "&after=" + item.id
        }
        return path + urlParams
    }
    
    func get(completion: @escaping(Result<RedditListingModel>) -> Void) {
        API.request(with: nil, to: self.path(), methodType: .GET) { (result) in
            switch result {
            case .success(let resultJson):
                if let arrayOfListModel = ListingModel.parseArrayOfListModel(with: resultJson) {
                    self.items += arrayOfListModel
                    completion(Result.success(self))
                }
            case .error(let error):
                completion(Result.error(e: error))
            }
        }
    }
}

class ListingModel {
    let id: String
    let title: String?
    let thumbnailUrl: String?
    
    init?(with json: DictionaryStringAnyObject) {
        guard let data = json["data"] as? DictionaryStringAnyObject,
            let id = data["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.title = data["title"] as? String
        self.thumbnailUrl = data["thumbnail"] as? String
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
