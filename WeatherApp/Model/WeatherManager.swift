//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Esa Anjum on 29/12/2020.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b96c6e32750123d23f3a236ab44b2178&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latidute: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latidute)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String) {
        //Create URL
        if let url = URL(string: urlString) {
            //Create URL Session
            let session = URLSession(configuration: .default)
            //Assign Session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    DispatchQueue.main.async {
                        
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(weather: weather)
                        }
                        
                    }
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let desc = decodedData.weather[0].description
            
            let feelsLike = decodedData.main.feels_like
            let tempMin = decodedData.main.temp_min
            let tempMax = decodedData.main.temp_max
            let pressure = decodedData.main.pressure
            let humid = decodedData.main.humidity
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, description: desc, feels_like: feelsLike,
                                       temp_min: tempMin, temp_max: tempMax, pressure: pressure, humidity: humid)
           
            return weather
            
        } catch {
            print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


