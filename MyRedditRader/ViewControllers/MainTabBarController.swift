//
//  MainTabBarController.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 21/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.viewControllers?.first as? UINavigationController,
            let listingViewController = navigationController.topViewController as? ListingViewController {
            listingViewController.onlyFavorite = false
        }
    }
}
