//
//  Coordinate.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct Coordinate {
	
	let latitude: Double
	let longitude:  Double
	
}

extension Coordinate: CustomStringConvertible {
	var description: String {
		return "\(latitude),\(longitude)"
	}
}
