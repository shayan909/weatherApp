

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var info = ["Feels Like °C:","Minimum °C:","Maximum °C:","pressure hPa","Humidity %"]
    var values = [String]()
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var tableView: UITableView!
    
    var pinTitle: String?
    var lat: Double!
    var lon: Double!
    
    let manager = CLLocationManager()
    var weatherManager = WeatherManager()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        let tabBar = tabBarController as! MyTabBarController
        pinTitle = tabBar.temp
        
        
        
    }
    //Mark: - Fetch Location For Map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    func render(_ location: CLLocation){
        
        let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        pin.title = pinTitle
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        let tabBar = tabBarController as! MyTabBarController
        pinTitle = tabBar.temp
        
        for _ in info{
            values.append(tabBar.feels_like)
            values.append(tabBar.temp_min)
            values.append(tabBar.temp_max)
            values.append(tabBar.pressure)
            values.append(tabBar.humidity)
        }
        
        lat = tabBar.lat
        lon = tabBar.lon
        self.tableView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
}



extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.testLabel.text = values[indexPath.row]
        cell.test2Label.text = info[indexPath.row]
        return cell
        
    }
    
    
    
    
    
}
