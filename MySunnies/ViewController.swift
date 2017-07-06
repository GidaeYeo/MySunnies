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
	let coordinate = Coordinate(latitude: 37.5665, longitude: 126.9780)
	let location = "Sydney"
	var latitude: CLLocationDegrees?
	var longitude: CLLocationDegrees?

	override func viewDidLoad() {
		super.viewDidLoad()
		getPermission()
		getCurrentWeather()
		
		self.getCoordinate(location: location) { (success, coordinates) in
			if success {
				self.latitude = coordinates.latitude
				self.longitude = coordinates.longitude
				//print("latitude: \(String(describing: self.latitude)), longitude: \(String(describing: self.longitude))")
			} else {
				print("Something went wrong!")
			}
		}
		//print("latitude: \(String(describing: latitude)), longitude: \(String(describing: longitude))")
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	func displayWeather (using viewModel: CurrentWeatherViewModel) {
		print(CurrentWeather.Key.summary)
		temperatureLabel.text = viewModel.temperature
		forecastIcon.image = viewModel.icon
		forecastLabel.text = viewModel.summary
	}
	
	
	
	func getPermission() {
		//Get permission from th user to track the user's location
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
	}

	func getCurrentWeather()  {
		client.getCurrentWeather(at: coordinate) { currentWeather, error in
			if let currentWeather = currentWeather {
				let viewModel = CurrentWeatherViewModel(model: currentWeather)
					self.displayWeather(using: viewModel)
			}
		}
	}
	
	func getCoordinate(location: String, completion: @escaping (Bool,  CLLocationCoordinate2D) -> ()) {
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(location) { placeMarks, error in
			
			if error != nil {
				print(error?.localizedDescription as Any)
			} else {
				if (placeMarks?.count)! > 0 {
					let placeMark = placeMarks?.first!
					let location = placeMark?.location
					completion(true, (location?.coordinate)!)
					print("location: \(String(describing: location?.coordinate.latitude)), \(String(describing: location?.coordinate.longitude))")
				}
			}
		}
	}


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourly", for: indexPath) as! HourlyForecastViewCell
		
		let resize = CGSize(width: 50, height: 50)
		
		client.getHourlyWeather(at: coordinate) { (hourlyWeather, error) in
			if let hourlyWeather = hourlyWeather {
				let viewModel = HourlyWeatherViewModel(model: hourlyWeather)
				//let convertedTimeArray = convertingToString(intTypeArray: viewModel.time)
				
				var celsiousTem = [String]()
				var tempCelsious: Double
				var temString: String
				for tem in viewModel.temperature {
					tempCelsious = (tem-32)*5/9
					temString = String(format: "%.0f", tempCelsious)
					celsiousTem.append(temString)
				}
				
				for temp in celsiousTem {
					cell.hourlyTempLabel.text = temp
				}
				//print("viewModel: \(viewModel.temperature)")
				var timeConverted: String
				//Display each individual time and image in the reusable cells
				
				//print(viewModel.time)
				for time in viewModel.time {
					timeConverted = timeStringFromUnixTime(unixTime: time)
					cell.hourlyTimeLabel.text = timeConverted
				}

				for image in viewModel.icon {
					cell.hourlyImageView.image = image.resizeImage(targetSize: resize)
				}
			}
		}
		
		return cell
	}
}


//Convert 
func timeStringFromUnixTime(unixTime: Int) -> String {
	let date = Date(timeIntervalSince1970: Double(unixTime))
	let dateFormatter = DateFormatter()
	dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
	dateFormatter.locale = Locale.current
	dateFormatter.dateFormat = "HH"
	return dateFormatter.string(from: date)
}

func convertingToString(intTypeArray: [Int]) -> [String] {
	var stringTypeArray = [String]()
	for integer in intTypeArray {
		stringTypeArray.append(String(integer))
	}
	return stringTypeArray
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



















