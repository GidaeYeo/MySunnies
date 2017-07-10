//
//  SearchResultsDataSource.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class SearchResultsDataSource: NSObject, UITableViewDataSource {
	
	private var data = [Region]()
	override init() {
		super.init()
	}
	
	func update(_ regions: [Region]) {
		data = regions
	}
	
	//Mark: - Data Source 
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
		let region = data[indexPath.row]
		cell.textLabel?.text = region.name
		return cell
	}
	
	//This function returns the data of a single region selected by the user
	func region(at indexPath: IndexPath) -> Region {
		return data[indexPath.row]
	}
}








































