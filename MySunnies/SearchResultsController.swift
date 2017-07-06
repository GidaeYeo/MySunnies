//
//  SearchResultsController.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController {

	let searchController = UISearchController(searchResultsController: nil)
	let dataSource = SearchResultsDataSource()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SearchResultsController.dismissSearchResultsController))
		
		tableView.tableHeaderView = searchController.searchBar
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchResultsUpdater = self
		tableView.dataSource = dataSource
		definesPresentationContext = true
    }

	func dismissSearchResultsController() {
		self.dismiss(animated: true, completion: nil)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

	//Mark: -Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showRegion" {
			if let indexPath = tableView.indexPathForSelectedRow {
				var region = dataSource.region(at: indexPath)
				
				//array of regions
				let regionListController = segue.destination as! RegionListController
				regionListController.region = region
			}
		}
	}

}

extension SearchResultsController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		dataSource.update(Stub.regions)
		tableView.reloadData()
	}
}
