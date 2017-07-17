//
//  DailyWeather .swift
//  MySunnies
//
//  Created by Justin Ji on 14/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct DailyWeather {
	let icon: [String]
	let temperatureMin: [Double]
	var temperatureMax: [Double]
}

extension DailyWeather {
	struct Key {
		static let icon = "icon"
		static let temperatureMin = "temperatureMin"
		static let temperatureMax = "temperatureMax"
	}
	
	init?(json: [String: Array<Any>]) {
		self.icon = json["icon"] as! [String]
		self.temperatureMin = json["temperatureMin"] as! [Double]
		self.temperatureMax = json["temperatureMax"] as! [Double]
	}
}













































