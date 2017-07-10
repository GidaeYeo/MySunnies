//
//  Stub.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct Stub {
	
	static var places: Region {
		return Region(name: "Wagga", locations: [])
	}
	
	static var locations: [Location] {
		let wagga = Location(city: "Wagga Wagga", state:  "NSW", country: "Australia", longitude: 147.3598, latitude: -35.1082)
		let syndey = Location(city: "Sydney", state: "NSW", country: "Australia", longitude: 151.2093, latitude: -33.8688 )
		let london = Location(city: "London", state: "London", country: "England", longitude: -0.118092, latitude: 51.509865)
		let newYork	= Location(city: "New York", state: "NY", country: "USA", longitude: -73.935242, latitude: 40.730610)
		let seoul = Location(city: "Seoul", state: "Seoul", country: "Republic of Korea", longitude: 127.024612, latitude: 37.532600)
		return [wagga, syndey, london, newYork, seoul]
	}
}
