//
//  WeatherViewModel.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 30/5/2023.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    func fetchWeather(completion: @escaping (Double?) -> Void) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.89&longitude=30.02&current_weather=true") else {
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
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(weather.currentWeather.temperature)
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
