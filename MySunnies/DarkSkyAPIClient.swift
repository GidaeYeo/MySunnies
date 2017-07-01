//
//  DarkSkyAPIClient.swift
//  MySunnies
//
//  Created by Justin Ji on 28/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

class DarkSkyAPIClient {
	
	fileprivate let darkSkyApiKey = "c4bb77c4cc1c434b1459eb3ee4883f65"
	lazy var baseUrl: URL = {
		return URL(string: "https://api.darksky.net/forecast/\(self.darkSkyApiKey)/")!
	}()
	
	
	let downloader = JSONDownloader()
	typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
	
	func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
		//1. create a url
		guard let url = URL(string: coordinate.description, relativeTo: baseUrl) else {
			completion(nil, .invalidURL)
			return
		}
	
		//2. create a request: now you can ask the JSON downloader to make a request on your behalf
		let request = URLRequest(url: url)
		
		//3. create a task and run it asynchronously
		let task = downloader.jsonTask(with: request) { (json, error) in
			DispatchQueue.main.async {
				guard let json = json  else {
					completion(nil, error)
					return
				}
				
				guard let currentWeatherJson = json["currently"] as? [String: AnyObject],
					let currentWeather = CurrentWeather(json: currentWeatherJson) else {
						completion(nil, .jsonParsingFailure)
						return
				}
				completion(currentWeather, nil)
			}
		}
		task.resume()
		
	}
}































