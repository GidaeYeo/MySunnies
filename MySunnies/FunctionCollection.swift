//
//  FunctionCollection.swift
//  MySunnies
//
//  Created by Justin Ji on 16/07/2017.
//  Copyright © 2017 Justin Ji. All rights reserved.
//

import Foundation
import UIKit


//functions for conversion
func timeConverter(_  timeArray: [Double]) -> [String] {
	var convertedTimeArray = [String]()
	for time in timeArray {
		let convertedTime = timeStringFromUnixTime(unixTime: time)
		convertedTimeArray.append(convertedTime)
	}
	return convertedTimeArray
}

func timeStringFromUnixTime(unixTime: Double) -> String {
	let date = Date(timeIntervalSince1970: unixTime)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "hh a"
	return dateFormatter.string(from: date)
}

func getCelsiousDegree(_ tempArray: [Double]) -> [String] {
	var celsiousTem = [String]()
	var tempCelsious: Double
	var temString: String
	for tem in tempArray {
		tempCelsious = (tem-32)*5/9
		temString = String(format: "%.0f", tempCelsious)
		celsiousTem.append(temString)
	}
	return celsiousTem
}

func convertingToString(intTypeArray: [Int]) -> [String] {
	var stringTypeArray = [String]()
	for integer in intTypeArray {
		stringTypeArray.append(String(integer))
	}
	return stringTypeArray
}

func weekdaysConverter(day component: [Int]) -> [String] {
	var weekdays = [String]()
	
	for num in component {
		switch num {
		case 0:  weekdays.append("Sun")
		case 1:  weekdays.append("Mon")
		case 2:  weekdays.append("Tues")
		case 3:  weekdays.append("Wed")
		case 4:  weekdays.append("Thurs")
		case 5:  weekdays.append("Fri")
		case 6:  weekdays.append("Sat")
		default:  weekdays.append(" ")
		}
	}
	return weekdays
}

func getWeekdays() -> [String] {
	let now = Date()
	let calendar = Calendar.current
	let component = calendar.component(.weekday, from: now)
	var weekdays = [Int]()
	for num in (component - 1)...(component+5) {
		weekdays.append(num % 7)
	}
	
	let weekDaysConverted = weekdaysConverter(day: weekdays)
	return weekDaysConverted
}

