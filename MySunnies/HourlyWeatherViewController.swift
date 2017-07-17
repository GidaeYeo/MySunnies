//
//  HourlyWeatherViewController.swift
//  MySunnies
//
//  Created by Justin Ji on 14/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

private let reuseIdentifier = "hourly"

class HourlyWeatherViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	
	let client = DarkSkyAPIClient()
	var placesClient = GMSPlacesClient()

	var coordinates: CLLocationCoordinate2D?
	var cityName: String?
	
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

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		hourlyWeatherCollectionView.dataSource = self
		hourlyWeatherCollectionView.delegate = self
		placesClient = GMSPlacesClient.shared()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HourlyForecastViewCell
		
		var coordinatesToUse: Coordinate?
		
		//If the location data is received
		if coordinates != nil {
			coordinatesToUse = Coordinate(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
			//print("coordinatesToUse: \(String(describing: coordinatesToUse))")
			
			self.client.getHourlyWeather(at: coordinatesToUse!) { (hourlyWeather, error) in
				if let hourlyWeather = hourlyWeather {
					let viewModel = HourlyWeatherViewModel(model: hourlyWeather)
					
					//Temperature
					let convertedTemperature = getCelsiousDegree(viewModel.temperature)
					cell.hourlyTempLabel.text = "\(convertedTemperature[indexPath.row])º"
					
					//Time
					let convertedTime = timeConverter(viewModel.time)
					//print("time: \(convertedTime)")
					cell.hourlyTimeLabel.text = convertedTime[indexPath.row]
					
					//Icon
					var resizedImages = [UIImage]()
					for image in viewModel.icon {
						resizedImages.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
					}
					cell.hourlyImageView.image = resizedImages[indexPath.row]
				}
			}
		} else {
			//either when the app is firstly launched or no data is received from LocatoniViewController, give the current location by using placesClient
			placesClient.currentPlace(callback: { (placeLikelihoodList, error) in
				if let error = error {
					print("pick plce error: \(error.localizedDescription)")
				}
				
				if let defaultCoordinates = placeLikelihoodList?.likelihoods.first?.place.coordinate {
					coordinatesToUse = Coordinate(latitude: defaultCoordinates.latitude, longitude: defaultCoordinates.longitude)
					
					//print("coordinatesToUse1: \(String(describing: coordinatesToUse))")
					
					self.client.getHourlyWeather(at: coordinatesToUse!) { (hourlyWeather, error) in
						
						if let hourlyWeather = hourlyWeather {
							let viewModel = HourlyWeatherViewModel(model: hourlyWeather)
							
							//Temperature
							let convertedTemperature = getCelsiousDegree(viewModel.temperature)
							cell.hourlyTempLabel.text =  "\(convertedTemperature[indexPath.row])º"
							//Time
							
							let convertedTime = timeConverter(viewModel.time)
							print("viewModel.time: \(viewModel.time)")
							cell.hourlyTimeLabel.text = convertedTime[indexPath.row]
							
							
							//Icon
							var resizedImages = [UIImage]()
							for image in viewModel.icon {
								resizedImages.append(image.resizeImage(targetSize: CGSize(width: 50, height: 50)))
							}
							cell.hourlyImageView.image = resizedImages[indexPath.row]
						}
					}
					
				}
			})
		}

    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
