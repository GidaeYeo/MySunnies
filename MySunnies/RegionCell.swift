//
//  RegionCell.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

//This model provides the result data of the region which the user searched for. 
class RegionCell: UITableViewCell {

	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var stateLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	static let reuseIdentifier = "RegionCell"
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
