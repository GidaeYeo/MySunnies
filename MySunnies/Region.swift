//
//  Region.swift
//  MySunnies
//
//  Created by Justin Ji on 06/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

class Region {
	let name: String
	var locations: [Location]
	init(name: String, locations: [Location]) {
		self.name = name
		self.locations = locations
	}
}
