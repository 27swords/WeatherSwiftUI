//
//  WeatherView.swift
//  WeatherSwiftUI
//
//  Created by Alexander Chervoncev on 29/5/2023.
//

import SwiftUI
import CoreData

struct WeatherView: View {
    
    //MARK: - Inits
    private let weatherViewModel = WeatherViewModel()
    @State var startAnimation: CGFloat = 0
    @State private var temperature: Double?
    @State private var cityName: String?
    @State private var weatherDescription: String?
    
    //MARK: - Views
    var body: some View {
        let waveGradient = LinearGradient(gradient: Gradient(colors: [
            Color(UIColor(hex: "#EE3A32")),
            Color(UIColor(hex: "#EF803B")),
            Color(UIColor(hex: "#EBAC38")),
            Color(UIColor(hex: "#D7C05E")),
            Color(UIColor(hex: "#ABC770")),
            Color(UIColor(hex: "#55C1DC"))
        ]), startPoint: .top, endPoint: .bottom)
        
        let strokeGradient = LinearGradient(gradient: Gradient(colors: [
            Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.8),
            Color(red: 0.93, green: 0.94, blue: 0.97, opacity: 1)
        ]), startPoint: .top, endPoint: .bottom)
        
        ZStack {
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack(alignment: .top) {
                    VStack {
                        //Name of the city
                        Text(cityName ?? "cityName")
                            .font(.system(size: 55))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor(hex: "#3c6382")).opacity(0.6))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.top, 10)
                        
                        //description of the weather
                        Text(weatherDescription ?? "weatherDescription")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor(hex: "#3c6382")).opacity(0.6)).opacity(0.8)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        Rectangle()
                            .foregroundColor(.white).opacity(0.6)
                            .frame(width: size.width, height: 5)
                    }
                    .frame(width: size.width, height: size.height, alignment: .top)
                }
                
                //temperature celsius
                ZStack(alignment: .leading) {
                    Text("\(Int(temperature?.toCelsius() ?? 0))°")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                        .foregroundColor(.white).opacity(0.8)
                        .multilineTextAlignment(.trailing)
                        .padding(.top, -240)
                        .padding(.leading, 100)
                    
                    //thermometer capsule
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: "#ECECEC")), Color(UIColor(hex: "#FFFFFF"))]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 96, height: 456)
                        .mask(RoundedRectangle(cornerRadius: 48))
                        .opacity(0.8)
                    
                    //capsule reflection
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor(hex: "#ecf0f1")).opacity(0.8))
                        .frame(width: 50, height: 406)
                        .mask(RoundedRectangle(cornerRadius: 48))
                        .blur(radius: 32)
                        .offset(x: 50)
                    
                    //the first wave
                    WaterWave(progress: CGFloat(temperature?.toCelsius() ?? 0) / 100, waveHeight: 0.04, offset: startAnimation + 190)
                        .fill(waveGradient)
                        .frame(width: 96, height: 456)
                        .mask(RoundedRectangle(cornerRadius: 48))
                        .opacity(0.5)
                    
                    //the second wave
                    WaterWave(progress: CGFloat(temperature?.toCelsius() ?? 0) / 100, waveHeight: 0.04, offset: startAnimation)
                        .fill(waveGradient)
                        .frame(width: 96, height: 456)
                        .mask(RoundedRectangle(cornerRadius: 48))
                        .opacity(0.5)
                    
                    //the outline of the thermometer
                    RoundedRectangle(cornerRadius: 48)
                        .strokeBorder(strokeGradient, lineWidth: 6)
                        .frame(width: 97, height: 456)
                    
                    //the first reflection
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .frame(width: 26, height: 390)
                        .mask(RoundedRectangle(cornerRadius: 48))
                        .blur(radius: 9)
                        .opacity(0.5)
                        .blendMode(.overlay)
                        .offset(x: 67, y: 20)
                    
                    //second reflection
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .frame(width: 12, height: 370)
                        .mask(RoundedRectangle(cornerRadius: 48))
                        .blur(radius: 7)
                        .opacity(0.3)
                        .blendMode(.overlay)
                        .offset(x: 6, y: 20)
                }
                .frame(width: size.width, height: size.height, alignment: .leading)
                .offset(x: 40, y: 40)
                .onAppear {
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        startAnimation = size.width
                    }
                    //Fetching data
                    weatherViewModel.fetchWeather { temp, name, description in
                        self.temperature = temp
                        self.cityName = name
                        self.weatherDescription = description
                    }
                }
            }
        }
    }
}

//MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
