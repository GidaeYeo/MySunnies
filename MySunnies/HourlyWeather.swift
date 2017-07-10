//
//  HourlyWeather.swift
//  MySunnies
//
//  Created by Justin Ji on 02/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct HourlyWeather {
	let icon: [String]
	let time: [Double]
	let temperature: [Double]
}

extension HourlyWeather {
	struct Key {
		static let icon = "icon"
		static let time = "time"
		static let temperature = "temperature"
	}
	
	init?(json: [String: Array<Any>]) {
		//json is a dictionary  of arrays which has two keys "icon" and "time", and their values are arrays.
		self.icon = json["icon"] as! [String]
		self.time = json["time"] as! [Double]
		self.temperature = json["temperature"] as! [Double]
	}
}
