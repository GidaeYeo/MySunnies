//
//  RegionListDataSource.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class RegionListDataSource: NSObject, UITableViewDataSource {

	private let locations: [Location]
	
	init(location: [Location]) {
		self.locations = location
		super.init()
	}
	
	
	//Mark: - Data Source 
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return locations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let regionCell = tableView.dequeueReusableCell(withIdentifier: RegionCell.reuseIdentifier, for: indexPath) as! RegionCell
		
		//print("haha: \(locations)")
		let location = locations[indexPath.row]
		let viewModel = RegionViewModel(viewModel: location)
		
		regionCell.cityLabel.text = viewModel.city
		regionCell.stateLabel.text = viewModel.state
		regionCell.countryLabel.text = viewModel.country
		return regionCell
		
	}
	
	func location(at indexPath: IndexPath) -> Location {
		return locations[indexPath.row]
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0: return "Regions"
		default: return nil
		}
	}
	
}






































