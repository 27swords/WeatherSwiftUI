//
//  WaterWaveS.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 30/5/2023.
//

import SwiftUI

struct WaterWaveS: Shape {
    
    var progress: CGFloat
    
    // Wave Height
    var waveHeight: CGFloat
    // Initial Animation Start
    var offset: CGFloat

    //Enabling animation
    
    var animatableData: CGFloat{
        get{offset}
        set{offset = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: .zero)
            
            //Mark: Drawing Waves using Sine
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, through: rect.width, by: 1){
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Bottom Portion
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
