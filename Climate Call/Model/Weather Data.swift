//
//  Weather Data.swift
//  Climate Call
//
//  Created by Nick Dubauskas on 10/26/23.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
    let temp_max: Double
    let temp_min: Double
}

struct Weather: Codable{
    let id: Int
   
}
