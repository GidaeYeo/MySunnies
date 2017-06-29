//
//  DarkSkyAPIClient.swift
//  MySunnies
//
//  Created by Justin Ji on 28/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

class DarkSkyAPIClient {
	
	fileprivate let darkSkyApiKey = "c4bb77c4cc1c434b1459eb3ee4883f65"
	lazy var baseUrl: URL = {
		return URL(string: "https://api.darksky.net/forecast/\(self.darkSkyApiKey)/")!
	}()
	
	
}
