//
//  RegionListDataSource.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class RegionListDataSource: NSObject, UITableViewDataSource {

	private let region: Region
	
	init(region: Region) {
		self.region = region
		super.init()
	}
	
	
	//Mark: - Data Source 
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let regionCell = tableView.dequeueReusableCell(withIdentifier: RegionCell.reuseIdentifier, for: indexPath) as! RegionCell
		
		let viewModel = RegionViewModel(viewModel: region)
		regionCell.configure(with: viewModel)
		regionCell.accessoryType = .disclosureIndicator
		return regionCell
		
	}
	
}






































