//
//  DarkSkyError.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

enum DarkSkyError: Error {
	case requestFailed
	case responseUnsuccessful
	case invalidData
	case jsonConversionFailure
	case invalidURL
	case jsonParsingFailure
}
