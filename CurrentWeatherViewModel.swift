//
//  CurrentWeatherViewModel.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
	let temperature: String
	let humidity: String
	let precipitationProbability: String
	let summary: String
	let icon: UIImage
	
	init(model: CurrentWeather) {
		//Converting the dicimal numbers  from CurrentWeather into integers to display
		let roundedTemperature = Int(model.temperature)
		let celsiousTemp = (roundedTemperature-32)*5/9
		self.temperature = "\(celsiousTemp)º"
		let humidityPercentValue = Int(model.humidity*100) //mutiply 10 to format it in a percentage type
		self.humidity = "\(humidityPercentValue)%"
		let percipPercentValue = Int(model.precipitationProbability * 100)//mutiply 10 to format it in a percentage type
		self.precipitationProbability = "\(percipPercentValue)%"
		self.summary = model.summary
		
		//the icons are string types that return weather images, according to the weather condition.
		let weatherIcon = WeatherIcon(iconString: model.icon)
		self.icon = weatherIcon.image
		
	}
}





















