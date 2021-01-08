//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Esa Anjum on 29/12/2020.

//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
    
    
}

struct Current: Codable {
    let temp: Double
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
    
    
}
 
struct Weather: Codable {
    
    let id: Int
    let description: String
}
