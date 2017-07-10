//
//  HourlyWeatherViewModel.swift
//  MySunnies
//
//  Created by Justin Ji on 02/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation
import UIKit

struct HourlyWeatherViewModel {
	let icon: [UIImage]
	let time: [Double]
	let temperature: [Double]
	
	init(model: HourlyWeather) {
		
		var weatherIconImage = [UIImage]()
		var weatherImage: WeatherIcon
		for imageString in model.icon {
			weatherImage = WeatherIcon(iconString: imageString)
			weatherIconImage.append(weatherImage.image)
		}
		
		self.icon = weatherIconImage
		self.time = model.time
		self.temperature = model.temperature
	}
}
