//
//  WeatherModel.swift
//  Clima
//
// Created by George Ovidiu SFETCU on 24.04.2024.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherModel, weather: WeatherObject)
    func didFailWithError(error: Error)
}

struct WeatherModel {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=98a88c5824231cb1f4688488eba7e4b0&units=metric"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let url  =  "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: url)
        
    }
    
    func fetchWeather(lat: Double,long: Double ){
        let url = "\(weatherUrl)&lat=\(lat)&lon=\(long)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        
        // create url
        if let url = URL(string: urlString) {
            // create url session
            let session =  URLSession(configuration: .default)
            
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = parseJson(weatherData: safeData) {
                        delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
                
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseJson( weatherData : Data) -> WeatherObject? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherObject = WeatherObject(conditionId: result.weather[0].id, cityName: result.name, temperature: result.main.temp)
            return weatherObject;
        } catch {
            debugPrint("An error occured while parsing weather data: \(error)")
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
