//
//  JSONDownLoader.swift
//  MySunnies
//
//  Created by Justin Ji on 29/06/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation

//this class is to
class JSONDownloader {
	
	let session: URLSession
	//URLSessionConfiguration is going to be created in an initialisation
	init(configuration: URLSessionConfiguration) {
		self.session = URLSession(configuration: configuration)
	}
	
	/*
	convenience initialiser:
	- Convenience initializers are secondary, supporting initializers for a class. You can define a convenience initializer to call a designated initializer from the same class as the convenience initializer with some of the designated initializer’s parameters set to default values. You can also define a convenience initializer to create an instance of that class for a specific use case or input value type.
	
	*/
	//creating a convenience init to set the instance of URLSessionConfiguration to default
	convenience init() {
		self.init(configuration: .default)
	}
	
	typealias JSON = [String: AnyObject] //creating JSON type
	typealias JSONTaskCompletionHandler = (JSON?, DarkSkyError?) -> Void
	
	//	jsonTask takes a request, creates a DataTask and is going to return that dataTask.
	func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
		let task = session.dataTask(with: request) { data, response, error in
			//			In this body, if you have data from the server, you are going to covert it to JSON by using JSONSerialization class.
			//			In the parameter, response contains information about how the request was processed. URLSession then takes this response and uses it to create an instance of URLResponse, which is what the type of this argument is.
			//			If you have errors, you will try and filter them to a few relevant ones and then pass them on.
			
			//Convert to HTTP response
			//When you have a case where you don't have a valid response, you can call the closure and provide nil for the JSON
			guard let httpResponse = response as? HTTPURLResponse else  {
				completion(nil, .requestFailed)
				return
			}
			if httpResponse.statusCode == 200 {
				if let data = data {
					//finally you received the valid JSON data from the server.
					//Convert the data to JSON by using JSONSerialization and cast the resulting object to a dictionary
					
					do {
						let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
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

























