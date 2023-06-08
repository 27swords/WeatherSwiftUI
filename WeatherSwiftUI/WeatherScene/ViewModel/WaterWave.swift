//
//  WaterWave.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 30/5/2023.
//

import SwiftUI

struct WaterWave: Shape {
    
    ///progress: A CGFloat value representing the progress of the wave animation. It should be in the range [0, 1], where 0 represents the wave at its lowest point and 1 represents the wave at its highest point.
    var progress: CGFloat
    ///waveHeight: A CGFloat value representing the relative height of the wave. It should be in the range [0, 1], where 0 represents no wave and 1 represents a full wave.
    var waveHeight: CGFloat
    ///offset: A CGFloat value representing the offset of the wave animation. It can be used to animate the wave horizontally.
    var offset: CGFloat
    
    ///animatableData: A computed property that returns the offset value. This property allows SwiftUI to animate the offset property automatically.
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    ///path(in rect: CGRect) -> Path: This method is required by the Shape protocol. It returns a Path object that represents the shape of the wave. The wave is drawn using a series of lines and moves. The rect parameter represents the bounding rectangle of the shape.
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: rect.height))
            
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            let startX: CGFloat = -rect.width * 0.25
            let endX: CGFloat = rect.width * 1.25
            
            let step: CGFloat = 1
            
            for x in stride(from: startX, through: endX, by: step) {
                let sine: CGFloat = sin((x + offset) * .pi / (rect.width * 2))
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
