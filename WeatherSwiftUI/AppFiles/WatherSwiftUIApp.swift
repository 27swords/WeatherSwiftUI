//
//  WatherSwiftUIApp.swift
//  WatherSwiftUI
//
//  Created by Alexander Chervoncev on 29/5/2023.
//

import SwiftUI

@main
struct WatherSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
