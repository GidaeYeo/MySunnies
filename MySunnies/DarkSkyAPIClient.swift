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
		return URL(string: "https://api.darksky.net/forecast/\(self.darkSkyApiKey)/?exclude=currently,minutely,hourly,alerts,flags&units=si&lang=en")!
	}()
	
	let downloader = JSONDownloader.Downloader1()
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
				//print("currentWeatherJson: \(currentWeatherJson)")
				completion(currentWeather, nil)
			}
		}
		task.resume()
		
	}
	
	let downloader2 = JSONDownloader.Downloader2()
	
	typealias HourlyWeatherCompletionHandler = (HourlyWeather?, DarkSkyError?) -> Void
	typealias DailyWeatherCompletionHandler = (DailyWeather?, DarkSkyError?) -> Void
	
	func getHourlyWeather(at coordinate: Coordinate, completionHandler completion: @escaping HourlyWeatherCompletionHandler) {
		guard let url = URL(string: coordinate.description, relativeTo: baseUrl) else {
			completion(nil, .invalidURL)
			return
		}
		let request = URLRequest(url: url)
		let task = downloader2.jsonTask(with: request) { (json, error) in
			DispatchQueue.main.async {
				guard let json = json else {
					completion(nil, error)
					return
				}
				
				//print("json: \(json)")
				
				let hourlyData = json["hourly"] as? [String: AnyObject]
				
				//print("hourlyData: \(hourlyData)")
				let hourlyDetail = hourlyData?["data"] as? [[String: AnyObject]]
				
				var timeArray = [Double]()
				var iconArray = [String]()
				var temperatureArray = [Double]()
				
				for detail in hourlyDetail! {
					iconArray.append(detail["icon"] as! String)
					timeArray.append(detail["time"] as! Double)
					temperatureArray.append(detail["temperature"] as! Double)
				}
				let detailDictionary = ["time": timeArray, "icon": iconArray, "temperature": temperatureArray] as [String : Any]
				guard let hourlyWeather = HourlyWeather(json: detailDictionary as! [String : Array]) else {
					completion(nil, .jsonParsingFailure)
					return
				}
			
				completion(hourlyWeather, nil)
				
			}
		}
		
		task.resume()
	}
	
	func getDailyWeather(at coordinate: Coordinate, completionHandler completion: @escaping DailyWeatherCompletionHandler) {
		guard let url = URL(string: coordinate.description, relativeTo: baseUrl) else {
			completion(nil, .invalidURL)
			return
		}
		let request = URLRequest(url: url)
		let task = downloader2.jsonTask(with: request) { (json, error) in
			DispatchQueue.main.async {
				guard let json = json else {
					completion(nil, error)
					return
				}
				
				let dailyData = json["daily"] as? [String: AnyObject]
				//print("dailyData: \(String(describing: dailyData))")
				let dailyDetail = dailyData?["data"] as? [[String:AnyObject]]
				
				var dailyIcons = [String]()
				var dailytemperatureMin = [Double]()
				var dailytemperatureMax = [Double]()
				
				for detail  in dailyDetail! {
					dailyIcons.append(detail["icon"] as! String)
					dailytemperatureMin.append(detail["temperatureMin"] as! Double)
					dailytemperatureMax.append(detail["temperatureMax"] as! Double)
				}
				
				let dailyDetailDictionary = ["icon": dailyIcons, "temperatureMin" : dailytemperatureMin, "temperatureMax": dailytemperatureMax] as [String: Any]
				
				guard let dailyWeather = DailyWeather(json: dailyDetailDictionary as! [String: Array]) else {
					completion(nil, .jsonParsingFailure)
					return
				}
				completion(dailyWeather, nil)
			}
		}
	
		task.resume()
	}
}
	


























