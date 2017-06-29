//
//  ViewController.swift
//  MySunnies
//
//  Created by Justin Ji on 28/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var regionLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var weatherLabel: UILabel!
	@IBOutlet weak var weatherIcon: UIImageView!
	
	@IBOutlet weak var umbrellaLabel: UILabel!
	@IBOutlet weak var sunniesLabel: UILabel!
	@IBOutlet weak var sunBlockLabel: UILabel!
	
	var forecastData = [Weather]()
	let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getCurrentWeather()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func getCurrentWeather () {
		
		//Get permission from th user to track the user's location
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
		
	}

	@IBAction func chooseRegion(_ sender: Any) {
		
	}
	
	
	@IBAction func seeHourly(_ sender: Any) {
	}

}































