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
	
	//This initialiser is going to help configure the session created right above
	init(configuration: URLSessionConfiguration) {
		self.session = URLSession(configuration: configuration)
	}
	
	//Creating a convenience initailiser to set the instance of URLSessionConfiguration to default
	convenience init() {
		self.init(configuration: .default)
	}
	
	typealias JSON = [String: AnyObject] //Creating a JSON type as dictionary
	typealias JSONTaskCompletionHandler = (JSON?, DarkSkyError? ) -> Void
	
	//this function takes a url request and 
	func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler)
		-> URLSessionDataTask {
			
			//with the results of the request "data, response, error"
			let task = session.dataTask(with: request) {data, response, error in
				guard let httpResponse = response as? HTTPURLResponse else {
						completion(nil, .requestFailed)
					return
				}
				
				//if the http response has been successfully received, start JSON serialisation
				if httpResponse.statusCode == 200 {
					if let data = data {
						do {
							//creating an object of JSONserialisation as the type JSON in an array
							let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
							completion(json, nil)
						} catch {
							completion(nil, .jsonConversionFailure)
						}
					} else {
						//when the data received is nil
						completion(nil, .invalidData)
					}
				} else {
					//when the http response has gone wrong
					completion(nil, .responseUnsuccessful)
				}
			}
			//when nothing has gone wrong with all the processes above,  return the task
			return task
	}
	
	
}
























