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
        return ListingViewModel(channelName: "bitcoin", didUpdate: { [unowned self] (animated) in
//            self.reloadData(animated: animated)
                self.tableView.reloadData()
            }
            ,didError: { [unowned self] (animated) in
//                self.reloadData(animated: animated)
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .green
        
        self.tableView.addInfiniteScroll { (tableView) in
            self.viewModel.loadNextPage(with: tableView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listingDitalesViewController = segue.destination as? ListingDetailsWebViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let url = self.viewModel.redditListing.urlForItem(at: indexPath){
            listingDitalesViewController.url = url;
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//    }
}


class ReditListingCell: UITableViewCell{
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}


