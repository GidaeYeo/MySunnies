//
//  RegionListController.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class RegionListController: UITableViewController {

	private struct Constants {
		static let RegionCellHeight: CGFloat = 80
	}
	
	var region: Region!
	
	lazy var dataSource: RegionListDataSource = {
		return RegionListDataSource(region: self.region)
	}()
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.RegionCellHeight
	}
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}



















































