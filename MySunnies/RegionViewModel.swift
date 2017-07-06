//
//  RegionViewModel.swift
//  MySunnies
//
//  Created by Justin Ji on 06/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

struct RegionViewModel {
	let city: String
	let state: String
	let country: String
}

extension RegionViewModel {
	init(viewModel: Region) {
		self.city = viewModel.city
		self.state = viewModel.state
		self.country = viewModel.country
	}
}
