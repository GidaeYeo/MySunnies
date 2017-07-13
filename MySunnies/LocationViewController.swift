//
//  LocationViewController.swift
//  MySunnies
//
//  Created by Justin Ji on 12/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationViewController: UIViewController, GMSAutocompleteViewControllerDelegate {

	// OUTLETS
	
	// VARIABLES
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	// MARK: GOOGLE AUTO COMPLETE DELEGATE
	
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		print("Selected Location: \(place.coordinate)")
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
