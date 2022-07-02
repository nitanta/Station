//
//  StationmasterApp.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

@main
struct StationmasterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabedView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
