//
//  WeatherModel.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 30/5/2023.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Int
    let generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentWeather = "current_weather"
    }
}

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let temperature, windspeed: Double
    let winddirection, weathercode, isDay: Int
    let time: String

    enum CodingKeys: String, CodingKey {
        case temperature, windspeed, winddirection, weathercode
        case isDay = "is_day"
        case time
    }
}
