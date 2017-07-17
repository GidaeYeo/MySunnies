//
//  ViewController.swift
//  MySunnies
//
//  Created by Justin Ji on 28/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
	
	@IBOutlet weak var dailyCollectionView: UICollectionView!
	@IBOutlet weak var hourlyCollectionView: UICollectionView!
	
	//For current weather
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var refreshButton: UIButton!
	@IBOutlet weak var locationNameLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var weatherIcon: UIImageView!
	
	//declare an instance of GMSOlacesClient to give a defult location
	var placesClient = GMSPlacesClient()
	let darkSkyAPIClient = DarkSkyAPIClient()
	let locationManager = CLLocationManager()
	var coordinates: CLLocationCoordinate2D?
	var cityName: String?
	
	//Receive the coordinates of the user's location from LocationViewController
	@IBAction func unwindToVC1(segue:UIStoryboardSegue) {
		if segue.source is LocationViewController{
			if let dataReceived = segue.source as? LocationViewController {
				coordinates = dataReceived.coordinates
				cityName = dataReceived.cityName
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getPermission()
		getDefaultData()
		
		hourlyCollectionView.dataSource = self
		hourlyCollectionView.delegate = self
		
		dailyCollectionView.dataSource = self
		dailyCollectionView.delegate = self
		
		placesClient = GMSPlacesClient.shared()
	}

	override func viewWillAppear(_ animated: Bool) {
		if coordinates == nil {
			getDefaultData()
		} else {
			locationNameLabel.text = cityName!
			getCurrentWeather()
		}
		
		//Setting the index path of the collection view's cells to zero when retrieving data
		hourlyCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
		dailyCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)

	
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	//Mark: -Display
	
	//When the app is first launched, this function is going to be called and give the initial coordinates of the user's location
	func getDefaultData() {
		self.togggleRefreshAnimation(on: true)
		placesClient.currentPlace { (placeLikelihoodList, error) -> Void in
			if let error = error {
				print("pick plce error: \(error.localizedDescription)")
				self.togggleRefreshAnimation(on: false)
			}
			self.locationNameLabel.text = "No Current Place"
			
			if let placeLikelihoodList = placeLikelihoodList {
				let place = placeLikelihoodList.likelihoods.first?.place
				if let place = place {
					self.locationNameLabel.text = place.name
				}
				
				if let coordinates = placeLikelihoodList.likelihoods.first?.place.coordinate {
					let defualtCoordinates = Coordinate(latitude: coordinates.latitude, longitude: coordinates.longitude)
					//print("defualtCoordinates: \(defualtCoordinates)")
					self.darkSkyAPIClient.getCurrentWeather(at: defualtCoordinates, completionHandler: { (currentWeather, error) in
						if let currentWeather = currentWeather {
							let viewModel = CurrentWeatherViewModel(model: currentWeather)
							//print("viewModel: \(viewModel)")
							self.displayWeather(using: viewModel)
							self.togggleRefreshAnimation(on: false)
						}
					})
				}
			}
		}
	}
	
	func displayCityName(city name: Location) {
		self.locationNameLabel.text = name.city
	}
	
	func displayWeather (using viewModel: CurrentWeatherViewModel) {
		temperatureLabel.text = viewModel.temperature
		weatherIcon.image = viewModel.icon
		summaryLabel.text = viewModel.summary
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
		//print("currentWeather: \(coordinates)")
		if coordinates != nil {
			let coordinatesToUse = Coordinate(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
			darkSkyAPIClient.getCurrentWeather(at: coordinatesToUse, completionHandler: { (currentWeather, error) in
				let viewModel = CurrentWeatherViewModel(model: currentWeather!)
				self.displayWeather(using: viewModel)
				//print("viewModel: \(viewModel)")
				self.togggleRefreshAnimation(on: false)
				
			})
		}
	}

	func togggleRefreshAnimation(on: Bool) {
		refreshButton.isHidden = on
		if on { activityIndicator.startAnimating() } else { activityIndicator.stopAnimating() }
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 7
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	
		var coordinatesToUse: Coordinate?

		if collectionView == self.hourlyCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourly", for: indexPath) as! HourlyWeatherCollectionViewCell
			
			if coordinates != nil {
				coordinatesToUse = Coordinate(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
				self.darkSkyAPIClient.getHourlyWeather(at: coordinatesToUse!, completionHandler: { (hourlyWeather, error) in
					if let hourlyWeather = hourlyWeather {
						let viewModel = HourlyWeatherViewModel(model: hourlyWeather)
						
						//Temperature
						let convertedTemperature = getCelsiousDegree(viewModel.temperature)
						var hourlyTemperatures = [String]()
						
						for num in 0...7 {
							hourlyTemperatures.append(convertedTemperature[num])
						}
						cell.temperatureLabel.text = "\(hourlyTemperatures[indexPath.row])º"
						print("indexPath: \(indexPath)")
						print("hourlyTemperatures[2]: \(hourlyTemperatures[2])")
						print("hourlyTemperatures[3]: \(hourlyTemperatures[3])")
						let convertedTime = timeConverter(viewModel.time)
						//print("time: \(convertedTime)")
						cell.timeLabel.text = convertedTime[indexPath.row]
					

						//Icon
						var resizedImages = [UIImage]()
						for image in viewModel.icon {
							resizedImages.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
						}
						cell.weatherIcon.image = resizedImages[indexPath.row]
					}
				})
			} else {
				placesClient.currentPlace(callback: { (placeLikelihoodList, error) in
					if let error = error {
						print("pick plce error: \(error.localizedDescription)")
					}
					if let defaultCoordinates = placeLikelihoodList?.likelihoods.first?.place.coordinate {
						coordinatesToUse = Coordinate(latitude: defaultCoordinates.latitude, longitude: defaultCoordinates.longitude)
					
						self.darkSkyAPIClient.getHourlyWeather(at: coordinatesToUse!, completionHandler: { (hourlyWeather, error) in
							if let hourlyWeather = hourlyWeather {
								let viewModel = HourlyWeatherViewModel(model: hourlyWeather)
								
								//Temperature
								let convertedTemperature = getCelsiousDegree(viewModel.temperature)
								print("convertedTemperature: \(convertedTemperature)")
								
								var hourlyTemperatures = [String]()
								
								for num in 0...7 {
									hourlyTemperatures.append(convertedTemperature[num])
								}
								print("hourlyTemperatures: \(hourlyTemperatures)")
								cell.temperatureLabel.text = "\(hourlyTemperatures[indexPath.row])º"
								print("indexPath.row: \(indexPath.section)")
								//Time
								let convertedTime = timeConverter(viewModel.time)
								//print("time: \(convertedTime)")
								cell.timeLabel.text = convertedTime[indexPath.row]
								print("indexPath: \(indexPath)")

								//Icon
								var resizedImages = [UIImage]()
								for image in viewModel.icon {
									resizedImages.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
								}
								cell.weatherIcon.image = resizedImages[indexPath.row]
							}

						})
					}
				})
			}
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daily", for: indexPath) as! DailyWeatherCollectionViewCell
			
			if coordinates != nil {
				coordinatesToUse = Coordinate(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
				self.darkSkyAPIClient.getDailyWeather(at: coordinatesToUse!, completionHandler: { (dailyWeather, error) in
					if let dailyWeather = dailyWeather {
						let viewModel = DailyWeatherViewModel(model: dailyWeather)
						let temperatureMin = getCelsiousDegree(viewModel.temperatureMin)
						let temperatureMax = getCelsiousDegree(viewModel.temperatureMax)
						var resizedIcons = [UIImage]()
						let weekdays = getWeekdays()
						
						
						for image in viewModel.icon {
							resizedIcons.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
						}
						
						cell.temperatureMaxLabel.text = temperatureMax[indexPath.row]
						cell.temperatureMinLabel.text = temperatureMin[indexPath.row]
						cell.weatherIcon.image = resizedIcons[indexPath.row]
						
						cell.dayLabel.text = weekdays[indexPath.row]
						if cell.dayLabel.text == "Sun" {
							cell.dayLabel.textColor = UIColor.red
							cell.dayLabel.text = weekdays[indexPath.row]
						} else if cell.dayLabel.text == "Sat" {
							cell.dayLabel.textColor = UIColor.blue
						}


					}
				})
			} else {
				placesClient.currentPlace(callback: { (placeLikelihoodList, error) in
					if let error = error {
						print("pick plce error: \(error.localizedDescription)")
					}
					
					if let defaultCoordinates = placeLikelihoodList?.likelihoods.first?.place.coordinate {
						coordinatesToUse = Coordinate(latitude: defaultCoordinates.latitude, longitude: defaultCoordinates.longitude)
						
						self.darkSkyAPIClient.getDailyWeather(at: coordinatesToUse!, completionHandler: { (dailyWeather, error) in
							if let dailyWeather = dailyWeather {
								let viewModel = DailyWeatherViewModel(model: dailyWeather)
								let temperatureMin = getCelsiousDegree(viewModel.temperatureMin)
								let temperatureMax = getCelsiousDegree(viewModel.temperatureMax)
								var resizedIcons = [UIImage]()
								var weekdays = getWeekdays()

								for image in viewModel.icon {
									resizedIcons.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
								}
								
								cell.temperatureMaxLabel.text = temperatureMax[indexPath.row]
								cell.temperatureMinLabel.text = temperatureMin[indexPath.row]
								cell.weatherIcon.image = resizedIcons[indexPath.row]
								
								cell.dayLabel.text = weekdays[indexPath.row]
								if cell.dayLabel.text == "Sun" {
									cell.dayLabel.textColor = UIColor.red
									cell.dayLabel.text = weekdays[indexPath.row]
								} else if cell.dayLabel.text == "Sat" {
									cell.dayLabel.textColor = UIColor.blue
								}
								print("indexPath: \(indexPath)")
							}
						})
					}
					
				})
			}
			return cell
		}
	}
	
	
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















