//
//  DailyWeatherViewModel.swift
//  MySunnies
//
//  Created by Justin Ji on 14/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeatherViewModel {
	let icon: [UIImage]
	let temperatureMin: [Double]
	let temperatureMax: [Double]
	
	init(model: DailyWeather) {
		var weatherIconImage = [UIImage]()
		var weatherImage: WeatherIcon
		
		for imageString in model.icon {
			weatherImage = WeatherIcon(iconString: imageString)
			weatherIconImage.append(weatherImage.image)
		}
		
		self.icon = weatherIconImage
		self.temperatureMax = model.temperatureMax
		self.temperatureMin = model.temperatureMin
	}
	
}
