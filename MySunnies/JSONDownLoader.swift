//
//  JSONDownLoader.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

class JSONDownloader {
	
	class Downloader1 {
		let session: URLSession
		init(configuration: URLSessionConfiguration) {
			self.session = URLSession(configuration: configuration)
		}
		
		convenience init() {
			self.init(configuration: .default)
		}
		
		typealias JSON = [String: AnyObject]//creating JSON type
		typealias JSONTaskCompletionHandler = (JSON?, DarkSkyError?) -> Void
		
		//	jsonTask takes a request, creates a DataTask and is going to return that dataTask.
		func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
			let task = session.dataTask(with: request) { data, response, error in
				
				guard let httpResponse = response as? HTTPURLResponse else  {
					completion(nil, .requestFailed)
					return
				}
				if httpResponse.statusCode == 200 {
					if let data = data {
						
						do {
							let json = try JSONSerialization.jsonObject(with: data, options: [] ) as? JSON
							//print("json: \(json)")
							completion(json, nil)
						} catch {
							completion(nil, .jsonConversionFailure)
						}
					} else {
						// when data received is nil
						completion(nil, .invalidData)
					}
				} else  {
					//when the HTTP response went wrong
					completion(nil, .responseUnsuccessful)
				}
			}
			return task
		}

	}
	
	class Downloader2 {
		
		let session: URLSession
		init(configuration: URLSessionConfiguration) {
			self.session = URLSession(configuration: configuration)
		}
		
		convenience init() {
			self.init(configuration: .default)
		}
		
		typealias JSON = [String: AnyObject]//creating JSON type
		typealias JSONTaskCompletionHandler = (JSON?, DarkSkyError?) -> Void
		func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
			let task = session.dataTask(with: request) { data, response, error in
				
				guard let  httpResponse = response as? HTTPURLResponse else  {
					completion(nil, .requestFailed)
					return
				}
				if httpResponse.statusCode == 200 {
					if let data = data {
						do {
							let json = try JSONSerialization.jsonObject(with: data, options: [] ) as? JSON
							//print(json!)
							completion(json, nil)
						} catch {
							completion(nil, .jsonConversionFailure)
						}
					} else {
						// when data received is nil
						completion(nil, .invalidData)
					}
				} else  {
					//when the HTTP response went wrong
					completion(nil, .responseUnsuccessful)
				}
			}
			return task
		}
	}
}

























