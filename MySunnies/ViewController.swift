//
//  ViewController.swift
//  MySunnies
//
//  Created by Justin Ji on 28/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
	
	
	@IBOutlet var backgroundView: UIView!
	@IBOutlet weak var regionLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var forecastLabel: UILabel!
	@IBOutlet weak var forecastIcon: UIImageView!

	let client = DarkSkyAPIClient()
	let locationManager = CLLocationManager()
	let coordinate = Coordinate(latitude: 37.8267, longitude: -122.4233)

	

	override func viewDidLoad() {
		super.viewDidLoad()
		getCurrentWeather()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	func displayWeather (using viewModel: CurrentWeatherViewModel) {
		temperatureLabel.text = viewModel.temperature
		forecastIcon.image = viewModel.icon
		forecastLabel.text = viewModel.summary

	}
	

	
	func getCurrentWeather()  {
		//Get permission from th user to track the user's location
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()

		client.getCurrentWeather(at: coordinate) { currentWeather, error in
			if let currentWeather = currentWeather {
				let viewModel = CurrentWeatherViewModel(model: currentWeather)
					self.displayWeather(using: viewModel)
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourly", for: indexPath) as! HourlyForecastViewCell
		
		
		let resize = CGSize(width: 50, height: 50)
		let image = UIImage(named: "clear-day")?.resizeImage(targetSize: resize)
		
		cell.hourlyTimeLabel.text = "1 am"
		cell.hourlyImageView.image = image
		return cell
	}
}



extension UIImage {
	func resizeImage (targetSize: CGSize) -> UIImage {
	let size = self.size
	//if I put 100 and 150
	//to maintain the same ratio as original
	let widthRatio = targetSize.width / self.size.width // 100/500 = 0.2
	let heightRatio = targetSize.height / self.size.height// 150/600 = 0.25
	
	var newSize: CGSize
	if widthRatio > heightRatio {
		newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
	} else {
		newSize = CGSize(width: size.width * widthRatio /* 500*0.2  = 100*/, height: size.height * heightRatio/* 600*0.25  = 150 */)
	}
	
	let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height) 
	UIGraphicsBeginImageContextWithOptions(newSize, false, 5.0)
	self.draw(in: rect)
	let newImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return newImage!
	}
	
}



















