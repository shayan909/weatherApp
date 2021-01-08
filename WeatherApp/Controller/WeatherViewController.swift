
import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    //var temp = ""
    var lat = 0.0
    var lon = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    
}

//Mark: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type City Name"
            return false
        }
        else{
            
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        
    }
}

//Mark: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(weather: WeatherModel) {
        
        self.temperatureLabel.text = weather.temperatureString
        self.cityLabel.text = weather.cityName
        self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        self.descriptionLabel.text = weather.description
        // self.temp = weather.temperatureString
        
        let tabBar = tabBarController as! MyTabBarController
        tabBar.temp = weather.temperatureString
        tabBar.city = weather.cityName
        tabBar.lon = lon
        tabBar.lat = lat
        tabBar.feels_like = "\(weather.feels_like)"
        tabBar.temp_min = "\(weather.temp_min)"
        tabBar.temp_max = "\(weather.temp_max)"
        tabBar.pressure = "\(weather.pressure)"
        tabBar.humidity = "\(weather.humidity)"
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//Mark: - CLLocationManager

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latidute: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
