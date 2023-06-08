//
//  Extension+Double.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 7/6/2023.
//

import Foundation

extension Double {
    func toCelsius() -> Double {
        return self - 273.15
    }
}
