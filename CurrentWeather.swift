//
//  CurrentWeather.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct CurrentWeather {
	let temperature: Double
	let humidity: Double
	let precipitaionProbability: Double
	let summary: String
	let icon: String
}

extension CurrentWeather {
	
	//To access the key of the dictionary in JSON
	struct Key {
		static let temperature = "temperature"
		static let humidity = "humidity"
		static let precipitationProbability = "precipitationProbability"
		static let summary = "summary"
		static let icon = "icon"
	}
	
	init? (json: [String: AnyObject]) {
		//this initialiser takes the JSON weather data and covert it to double and string types
		guard let temValue = json[Key.temperature] as? Double,
		let humidityValue = json[Key.humidity] as? Double,
		let precipitationProbabilityValue = json[Key.precipitationProbability] as? Double,
		let summaryString = json[Key.summary] as? String,
			let iconString = json[Key.icon] as? String else {return nil}
		
		//initialising structure values with the converted ones above
		self.temperature = temValue
		self.humidity = humidityValue
		self.precipitaionProbability = precipitationProbabilityValue
		self.summary = summaryString
		self.icon = iconString
	}
}
