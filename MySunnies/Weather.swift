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
	
	
	init(json:[String:Any]) throws {
		guard let summary = json["summary"] as? String else {throw SerialisationError.missing("summary is missing")}
		
		guard let icon = json["icon"] as? String else {throw SerialisationError.missing("icon is missing")}
		
		guard let temperature = json["temperatureMax"] as? Double else {throw SerialisationError.missing("temp is missing")}
		
		self.summary = summary
		self.icon = icon
		self.temperature = temperature
	}
	
	static let basePath = "https://api.darksky.net/forecast/c4bb77c4cc1c434b1459eb3ee4883f65/"

	static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
		//Creating a communication path from client to server
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
						if let dailyForecasts = json["daily"] as? [String:Any] {
							if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
								for dataPoint in dailyData {
									if let weatherObject = try? Weather(json: dataPoint) {
										forecastArray.append(weatherObject)
									}
								}
							}
						}
						
					}
				}catch {
					print(error.localizedDescription)
				}
				
				completion(forecastArray)
				
			}
			
			
		}
		
		task.resume()
		
	}

}
