//
//  ViewController.swift
//  Weather(RomanovaL)
//
//  Created by Admin on 26.04.2022.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startLocationManager()
    }
    
    func startLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateView() {
        cityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        temperatureLabel.text = weatherData.main.temp.description + "°"
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
    }
    
    func updateWeatherInfo(latitude: Double, longtitude: Double){
        let session = URLSession.shared
        let url = URL(string: "api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&APPID=5567baf958fd7451e27d90246e7b1720&units=metric&lang=ru")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                }
                print(self.weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }


}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}
