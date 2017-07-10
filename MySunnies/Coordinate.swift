//
//  Coordinate.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation
import CoreLocation

class Coordinate {
	
	let latitude: Double
	let longitude:  Double
	init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
}

extension Coordinate: CustomStringConvertible {
	
	func getCoordinate(region location: String, completion: @escaping (Bool,  CLLocationCoordinate2D) -> ()) {
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(location) { placeMarks, error in
			
			if error != nil {
				print(error?.localizedDescription as Any)
			} else {
				if (placeMarks?.count)! > 0 {
					let placeMark = placeMarks?.first!
					let location = placeMark?.location
					completion(true, (location?.coordinate)!)
//					print("location: \(String(describing: location?.coordinate.latitude)), \(String(describing: location?.coordinate.longitude))")
				}
			}
		}
	}

	var description: String {
		return "\(latitude),\(longitude)"
	}
}
