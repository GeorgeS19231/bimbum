//
//  ViewController.swift
//  Clima
//
// Created by George Ovidiu SFETCU on 24.04.2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManagar  = WeatherModel()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManagar.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
 
    
}

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print("May this be the text \(searchTextField.text ?? "NONE")")
        if let city = searchTextField.text {
            weatherManagar.fetchWeather(cityName: city)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if  textField.text == "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text {
            weatherManagar.fetchWeather(cityName: city)
        }
        textField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: any Error) {
        debugPrint("An error occured \(error)")
    }
    
    func didUpdateWeather(weatherManager: WeatherModel, weather: WeatherObject) {
        DispatchQueue.main.sync{
            
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            cityLabel.text = weather.cityName
            temperatureLabel.text = String(format: "%0.f", weather.temperature)
        }
        
        print(weather.conditionName)
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            print("lat is: \(location.coordinate.latitude) and long is: \(location.coordinate.longitude)")
            weatherManagar.fetchWeather(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}


