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
	
	@IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var refreshButton: UIButton!
	@IBOutlet weak var regionLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var forecastLabel: UILabel!
	@IBOutlet weak var forecastIcon: UIImageView!
	@IBAction func unwindToView(segue: UIStoryboardSegue){ }

	let client = DarkSkyAPIClient()
	let locationManager = CLLocationManager()
	var coordinate = Coordinate(latitude: 37.5665, longitude: 126.9780) //default weather
	let location = "Current Location"
	var latitude: CLLocationDegrees?
	var longitude: CLLocationDegrees?
	var regionData: Location!
	var mainView: UICollectionView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getPermission()
		getCurrentWeather()
		self.hourlyWeatherCollectionView.dataSource = self
		self.hourlyWeatherCollectionView.delegate = self
		
	}

	override func viewWillAppear(_ animated: Bool) {
		if regionData == nil {
			regionLabel.text = location
		} else {
			displayCityName(city: regionData)
			getCurrentWeather()
		}
		
		hourlyWeatherCollectionView.reloadData()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	//Mark: -Display
	func displayCityName(city name: Location) {
		self.regionLabel.text = name.city
		
	}
	func displayWeather (using viewModel: CurrentWeatherViewModel) {
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

	//Mark: - Get Current Weather
	func getCurrentWeather()  {
		togggleRefreshAnimation(on: true)
		
		if regionData != nil {
			let longitude = regionData.longitude
			let latitude = regionData.latitude
			coordinate = Coordinate(latitude: latitude, longitude: longitude)
			
			client.getCurrentWeather(at: coordinate) { currentWeather, error in
				if let currentWeather = currentWeather {
					let viewModel = CurrentWeatherViewModel(model: currentWeather)
					self.displayWeather(using: viewModel)
					self.togggleRefreshAnimation(on: false)
				}
			}
		} else{
				client.getCurrentWeather(at: coordinate, completionHandler: { (currentWeather, error) in
					if let currentWeather = currentWeather {
						let viewModel = CurrentWeatherViewModel(model: currentWeather)
						self.displayWeather(using: viewModel)
						self.togggleRefreshAnimation(on: false)
						//print("when regionData is nil: \(self.coordinate)")
					}
				})
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
//					print("location: \(String(describing: location?.coordinate.latitude)), \(String(describing: location?.coordinate.longitude))")
				}
			}
		}
	}

	func togggleRefreshAnimation(on: Bool) {
		refreshButton.isHidden = on
		if on {
			activityIndicator.startAnimating()
		} else {
			activityIndicator.stopAnimating()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourly", for: indexPath) as! HourlyForecastViewCell
		
		
		if regionData != nil {
			coordinate = Coordinate(latitude: regionData.latitude, longitude: regionData.longitude)
		}

		client.getHourlyWeather(at: coordinate) { (hourlyWeather, error) in
			if let hourlyWeather = hourlyWeather {
				let viewModel = HourlyWeatherViewModel(model: hourlyWeather)

				//Temperature
				let convertedTemperature = getCelsiousDegree(viewModel.temperature)
				cell.hourlyTempLabel.text = convertedTemperature[indexPath.row]
				
				//Time
				let convertedTime = timeConverter(viewModel.time)
				cell.hourlyTimeLabel.text = convertedTime[indexPath.row]
				
				//Icon
				var resizedImages = [UIImage]()
				for image in viewModel.icon {
					resizedImages.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
				}
				cell.hourlyImageView.image = resizedImages[indexPath.row]
			}
		}
		
		return cell
	}
}


//functions for conversion
func timeConverter(_  timeArray: [Double]) -> [String] {
	var convertedTimeArray = [String]()
	for time in timeArray {
		let convertedTime = timeStringFromUnixTime(unixTime: time)
		convertedTimeArray.append(convertedTime)
	}
	return convertedTimeArray
}

func timeStringFromUnixTime(unixTime: Double) -> String {
	let date = Date(timeIntervalSince1970: unixTime)
	let dateFormatter = DateFormatter()
	dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
	dateFormatter.locale = Locale.current
	dateFormatter.dateFormat = "hh a"
	return dateFormatter.string(from: date)
}

func getCelsiousDegree(_ tempArray: [Double]) -> [String] {
	var celsiousTem = [String]()
	var tempCelsious: Double
	var temString: String
	for tem in tempArray {
		tempCelsious = (tem-32)*5/9
		temString = String(format: "%.0f", tempCelsious)
		celsiousTem.append(temString)
	}
	return celsiousTem
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



















