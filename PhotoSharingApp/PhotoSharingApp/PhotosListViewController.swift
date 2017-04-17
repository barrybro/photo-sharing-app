//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import UIKit

class PhotosListViewController: UITableViewController {

    let viewModel: PhotosListViewModel

    fileprivate let reuseIdentifier = "photoCell"

    init(viewModel: PhotosListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.photosetTitle()

        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    // MARK: - UITableView Datasource and Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photoCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PhotoTableViewCell else {
            fatalError()
        }

        cell.photo = viewModel.photo(index: indexPath.row)
        return cell
    }
}
