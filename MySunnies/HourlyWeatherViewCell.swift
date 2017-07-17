//
//  HourlyWeatherViewCell.swift
//  MySunnies
//
//  Created by Justin Ji on 16/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit

class HourlyWeatherViewCell: UITableViewCell {

}

extension HourlyWeatherViewCell: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 8
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weather", for: indexPath) as! HourlyForecastViewCell
		
		
		
		return cell
	}
}

extension HourlyWeatherViewCell: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow:CGFloat = 4
		let hardCodedPadding:CGFloat = 5
		let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
		let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
		return CGSize(width: itemWidth, height: itemHeight)
	}
}
