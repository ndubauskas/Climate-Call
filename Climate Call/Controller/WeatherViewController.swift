//
//  ViewController.swift
//  Climate Call
//
//  Created by Nick Dubauskas on 10/26/23.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UIBarButtonItem!
    @IBOutlet weak var locationLabel: UIButton!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel! 
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    private var gradientLayer: CAGradientLayer?
    var weatherColor: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }

  
    @IBAction func getCurrentLocationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
}

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchTextPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if var city = searchTextField.text{
            if city.contains(" "){
                city = (city as NSString).replacingOccurrences(of: " ", with: "+")
            }
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        }
    
    func updateUI(_ weatherColor: Int){
        self.gradientLayer?.removeFromSuperlayer()
        let newGradientLayer = CAGradientLayer()
        let hexColor = UIColor(hex: weatherColor)
        newGradientLayer.colors = [hexColor.cgColor, UIColor.white.cgColor]
        newGradientLayer.locations = [0.0, 1.0]
        newGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        newGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.3)
        newGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(newGradientLayer, at: 0)
        self.gradientLayer = newGradientLayer
       // print(weatherColor.accessibilityName)
        
        if weatherColor == 0xE1DE2A {
            cityLabel.textColor = .black
            conditionImageView.tintColor = .black
            lowTempLabel.textColor = .black
            highTempLabel.textColor = .black
            temperatureLabel.textColor = .black
            settingsLabel.tintColor = .black
            locationLabel.tintColor = .black
           
        }
        else{
            cityLabel.textColor = .white
            conditionImageView.tintColor = .white
            lowTempLabel.textColor = .white
            highTempLabel.textColor = .white
            temperatureLabel.textColor = .white
            locationLabel.tintColor = .white
        }

        
    }
    
}

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
           DispatchQueue.main.async { [self] in
               temperatureLabel.text = weather.temperatureString + "°"
                weatherColor = getWeatherColor(weather: weather)
               updateUI(weatherColor)
               conditionImageView.image = UIImage(systemName: weather.conditionName)
               cityLabel.text = weather.cityName
               lowTempLabel.text = "L: " + weather.lowTempString + "°"
               highTempLabel.text = "H: " + weather.highTempString + "°"
          }
       }

    func didFailWithError(error: Error) {
        print(error)
        
    }

    func getWeatherColor(weather: WeatherModel) ->Int{

        
        switch Int(weather.temperature){
        
        //Dark Blue
        case 20...40:
            return 0x001596
        //Blue
        case 41...60:
            return 0x0015F0
        //Light Blue
        case 61...70:
            return 0x00D2F0
        //Yellow
        case 71...80:
            return 0xE1DE2A
        //Orange
        case 81...90:
            return 0xF09032
        //Red
        case 90...100:
            return 0xDC0010
        //Dark Red
        case 101...130:
            return 0x980010
        //Gray
        default:
            return 0x838283
        }
        
        
    }
}
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error from location manager \(error)")
    }
}
extension UIColor {
    convenience init(hex: Int) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
