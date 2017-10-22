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
    
    private lazy var viewModel: ListingViewModel = {
        return ListingViewModel(onlyFavorite: self.onlyFavorite, didUpdate: { [unowned self] (animated) in
                self.reload()
            }
            ,didError: { [unowned self] (animated) in
//                self.reloadData(animated: animated)
        })
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    lazy var onlyFavorite: Bool = {
        if let tabBarController = self.tabBarController,
            let viewControllers = tabBarController.viewControllers,
            let firstViewController = viewControllers.first as? UINavigationController,
            let firstViewControllerRootViewController = firstViewController.topViewController,
            firstViewControllerRootViewController == self {
            return false
        }
        return true
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = self.onlyFavorite ? "Favorites" : ListingManager.sharedInstance.channelName
        
        self.setupSearchController()
        self.setupInfiniteScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.onlyFavorite {
            self.reload()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listingDitalesViewController = segue.destination as? ListingDetailsWebViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let item = self.viewModel.items()[safe: indexPath.row] {
            listingDitalesViewController.listingModel = item
            listingDitalesViewController.showRemoveFromFavorite = self.onlyFavorite
        }
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func reload() {
        self.tableView.reloadData()
    }
    
    private func setupInfiniteScroll() {
        self.tableView.addInfiniteScroll { (tableView) in
            self.viewModel.loadNextPage(with: tableView)
        }
        
        self.tableView.setShouldShowInfiniteScrollHandler { (tableView) -> Bool in
            if self.onlyFavorite == true {
                return false
            }
            else {
                return (self.viewModel.mode != .searching)
            }
        }
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search " + (self.title ?? "")
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
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

extension ListingViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

class ReditListingCell: UITableViewCell{
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
