//
//  Weather.swift
//  MySunnies
//
//  Created by Justin Ji on 28/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
	let summary: String
	let icon: String
	let temperature: Double
	
	enum SerialisationError: Error {
		case missing(String)
		case invalid(String)
	}
	
	//This initialiser takes json data as in a dictionary
	init(json:[String:Any]) throws {
		guard let summary = json["summary"] as? String else {throw SerialisationError.missing("summary is missing")}
		
		guard let icon = json["icon"] as? String else {throw SerialisationError.missing("icon is missing")}
		
		guard let temperature = json["temperatureMax"] as? Double else {throw SerialisationError.missing("temp is missing")}
		
		self.summary = summary
		self.icon = icon
		self.temperature = temperature
	}
	
	//Building a base path to getting the current weather of the user's region
	static let basePath = "https://api.darksky.net/forecast/c4bb77c4cc1c434b1459eb3ee4883f65/"

	
	//This funciton takes the user's location and
	static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
		
		//Completing the url path by adding the latitude and longitude of the uers's location
		let url = basePath + "\(location.latitude),\(location.longitude)"
		
		//Creating a request via the url created above
		let request = URLRequest(url: URL(string: url)!)
		
		//Assigning a task
		let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
			
			//if you print the data retrieved from the server, it would show just the volume of the data: "data: 21520 bytes"
			print("data: \(data!)")
			
			//Creating an empty array to contain the converted data
			var forecastArray:[Weather] = []
			
			//JSON Serialisation
			if let data = data {
				do {
					//creating an object of JSONSerialization
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
							//if there is data about daily forecast which its key is "daily",
						if let dailyForecasts = json["daily"] as? [String:Any] {
								//As the value of dailyForecasts is also a dictionary, retrieve specific daily data by using the key "data" as array of dictionaries
							if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
								for dataPoint in dailyData {
									//if the each data in each dictionary is also formatted as the class "Weather" which its initialiser takes a dictionary in its parameter,
									if let weatherObject = try? Weather(json: dataPoint) {
										//append each data into the array of forecastArray
										forecastArray.append(weatherObject)
									}
								}
							}
						}
						
					}
				}catch {
					print(error.localizedDescription)
				}
				//when everything has gone right, complete it.
				completion(forecastArray)
			}
		}
		task.resume() 
	}

}
