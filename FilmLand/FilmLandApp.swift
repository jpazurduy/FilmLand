//
//  FilmLandApp.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/9/25.
//

import SwiftUI

@main
struct FilmLandApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
