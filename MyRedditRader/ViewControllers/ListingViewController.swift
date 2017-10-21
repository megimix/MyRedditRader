//
//  ListingViewController.swift
//  MyRedditRader
//
//  Created by Tal Shachar on 20/10/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//

import UIKit

class ListingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: ListingViewModel = {
        return ListingViewModel(onlyFavorite: self.onlyFavorite, didUpdate: { [unowned self] (animated) in
                self.reload()
            }
            ,didError: { [unowned self] (animated) in
//                self.reloadData(animated: animated)
        })
    }()
    
    var onlyFavorite: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.onlyFavorite == false {
            self.tableView.addInfiniteScroll { (tableView) in
                self.viewModel.loadNextPage(with: tableView)
            }
            self.title = ListingManager.sharedInstance.channelName
        }
        else {
            self.title = "Favorites"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.onlyFavorite {
            self.reload()
        }
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listingDitalesViewController = segue.destination as? ListingDetailsWebViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let item = self.viewModel.items()[safe: indexPath.row] {
            listingDitalesViewController.listingModel = item
            listingDitalesViewController.showRemoveFromFavorite = self.onlyFavorite
        }
    }
}

extension ListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.viewModel.getCell(with: tableView, At: indexPath)
    }
}

class ReditListingCell: UITableViewCell{
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}


