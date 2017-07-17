//
//  DailyWeatherViewCell.swift
//  MySunnies
//
//  Created by Justin Ji on 15/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class DailyWeatherViewCell: UICollectionViewCell {
	@IBOutlet weak var temperatureMaxLabel: UILabel!
	@IBOutlet weak var temperatureMinLabel: UILabel!
	@IBOutlet weak var dailyWeatherImage: UIImageView!
	@IBOutlet weak var dayLabel: UILabel!
	
	func getDailyWeatherIcon(using viewModel: CurrentWeatherViewModel) -> UIImage {
		let icon = viewModel.icon
		return icon
	}
}
