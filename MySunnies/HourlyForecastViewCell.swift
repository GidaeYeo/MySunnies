//
//  HourlyForecastViewCell.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class HourlyForecastViewCell: UICollectionViewCell {
	
	@IBOutlet weak var hourlyTimeLabel: UILabel!
	@IBOutlet weak var hourlyImageView: UIImageView!
	
	func getHourlyWeatherIcon(using viewModel: CurrentWeatherViewModel) -> UIImage {
		let icon = viewModel.icon
		return icon
	}
}

