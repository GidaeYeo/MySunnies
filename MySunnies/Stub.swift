//
//  Stub.swift
//  MySunnies
//
//  Created by Justin Ji on 05/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct Stub {
	static var regions: [Region] {
		let wagga = Region(city: "Wagga Wagga", state: "NSW", country: "Australia")
		let gangNam = Region(city: "GangNam", state: "Seoul", country: "Republic of Korea")
		return [wagga, gangNam]
	}
}
