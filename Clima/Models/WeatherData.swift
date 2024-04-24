//
//  WeatherData.swift
//  Clima
//
// Created by George Ovidiu SFETCU on 24.04.2024.
//

import Foundation

struct WeatherData: Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main: Decodable {
    let temp : Double
}

struct Weather : Decodable {
    let id: Int
    let main: String
    let description : String
    
}
