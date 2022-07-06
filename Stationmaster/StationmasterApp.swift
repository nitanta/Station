//
//  StationmasterApp.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI
import CoreData

@main
struct StationmasterApp: App {
    let persistenceController = PersistenceController.shared
    init() {
       debugPrint("DB path: \(Helpers.getFilePath)")
    }
    
    var body: some Scene {
        WindowGroup {
            TabedView()
                .environment(\.managedObjectContext, persistenceController.managedObjectContext)
        }
    }
}
