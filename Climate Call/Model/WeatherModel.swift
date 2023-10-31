//
//  WeatherModel.swift
//  Climate Call
//
//  Created by Nick Dubauskas on 10/27/23.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let highTemp: Double
    let lowTemp: Double
    var highTempString: String{
        return String(format: "%.1f", highTemp)
    }
    var lowTempString: String{
        return String(format: "%.1f", lowTemp)
    }
    var temperatureString: String{
        return String(format: "%.1f",temperature)
    }
    var conditionName: String {
        switch conditionId{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
    
 
