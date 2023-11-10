//
//  Weather Manager.swift
//  Climate Call
//
//  Created by Nick Dubauskas on 10/26/23.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    
    //Enter API key here
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOUR API KEY"
   
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){ (data, response, error ) in
                if error != nil{
                   
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON( safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let lowTemp = decodedData.main.temp_min
            let highTemp = decodedData.main.temp_max
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, highTemp: highTemp, lowTemp: lowTemp)
            
            //print(weather.conditionName)
            return weather
        }catch{
            print(error)
            self.delegate?.didFailWithError(error: error)
            
        }
        return nil
    }
  //  func getLocalTemp(_ weather)
    
}

