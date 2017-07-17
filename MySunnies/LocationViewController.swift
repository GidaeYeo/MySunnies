//
//  LocationViewController.swift
//  MySunnies
//
//  Created by Justin Ji on 12/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class LocationViewController: UIViewController, GMSAutocompleteViewControllerDelegate {

	
	var coordinates: CLLocationCoordinate2D?
	var cityName: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	// MARK: GOOGLE AUTO COMPLETE DELEGATE
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		print("Selected Location: \(place.name), \(place.coordinate)")
		
		coordinates = place.coordinate
		cityName = place.name
		func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
		performSegue(withIdentifier: "goBack", sender: self)
		self.dismiss(animated: true, completion: nil) // dismiss after select place
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		print("ERROR AUTO COMPLETE \(error)")
	}
	
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		self.dismiss(animated: true, completion: nil) // when cancel search
	}
	
	
	
	@IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		self.present(autoCompleteController, animated: true, completion: nil)
	}}
