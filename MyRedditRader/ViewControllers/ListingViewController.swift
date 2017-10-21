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


