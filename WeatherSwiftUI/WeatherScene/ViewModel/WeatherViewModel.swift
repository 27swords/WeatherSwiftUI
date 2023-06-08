//
//  WeatherViewModel.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 30/5/2023.
//

import Foundation
import CoreLocation

final class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    ///A CLLocationManager instance used to manage location-related operations.
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    ///Fetches weather data from the OpenWeatherMap API based on the user's current location. The weather data is passed to the completion closure as parameters (temperature, location name, weather description).
    func fetchWeather(completion: @escaping (Double?, String?, String?) -> Void) {
        guard let currentLocation = locationManager.location else {
            print("Current location is unavailable.")
            return
        }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        let apiKey = "188feff27096ff80d23cf888f4e9bbbe"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            do {
                print("Received data: \(String(data: data, encoding: .utf8) ?? "")")
                let weatherResponse = try JSONDecoder().decode(Weather.self, from: data)
                let weatherDescription = weatherResponse.weather?.first?.description
                let weatherName = weatherResponse.name
                let weatherTemperature = weatherResponse.main?.temp
                DispatchQueue.main.async {
                    completion(weatherTemperature, weatherName, weatherDescription)
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    ///A delegate method from the CLLocationManagerDelegate protocol. It is called when the authorization status for location services changes. If the status is authorized, it requests the user's location.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    ///A delegate method from the CLLocationManagerDelegate protocol. It is called when the location manager receives new location updates. It fetches weather data based on the updated location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.last != nil else {
            return
        }
        
        fetchWeather { weatherTemperature, weatherName, weatherDescription in
        }
    }
    
    ///A delegate method from the CLLocationManagerDelegate protocol. It is called when the location manager encounters an error.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}






