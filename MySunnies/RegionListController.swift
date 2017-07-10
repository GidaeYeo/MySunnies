//
//  RegionListController.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

protocol RegionListControllerDelegate: class {
	func didSendRegionData(_ region: Region)
}

class RegionListController: UITableViewController {
	
	var region: Region! //this variable contains the data of the selected region by the user
	
	lazy var dataSource: RegionListDataSource = {
		return RegionListDataSource(location: self.region.locations)
	}()
	//dataSource return an array of Location, which has 4 different location details
	
	//creating a delegate
	weak var delegate: RegionListControllerDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = dataSource
		//print("Region: \(region.locations)")
		//print("dataSource: \(dataSource)")

	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func goBackToMainView(_ sender: Any) {
		performSegue(withIdentifier: "backToView", sender: self)
	}
    // MARK: - Table view data source
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "backToView" {
			if let indexPath = tableView.indexPathForSelectedRow {
				let regionBackwords = dataSource.location(at: indexPath)
				
				//print("regionBackwords: \(regionBackwords)")
				let viewController = segue.destination as! ViewController
				viewController.regionData = regionBackwords
	
			}
		}
	}

}



















































