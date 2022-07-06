//
//  ContentView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct TabedView: View {
    
    @StateObject var viewModel = TabedViewModel()
    
    init() {}
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(AppColor.Components.TabBar.tint)
        } else {
            tabs
        }
    }
    
    var tabs: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                        .renderingMode(.template)
                    
                    Text(Constants.start)
                }
            
            ModeView()
                .tabItem {
                    Image(systemName: "exclamationmark.triangle")
                        .renderingMode(.template)
                    
                    Text(Constants.mode)
                }
            
            CardView()
                .tabItem {
                    Image(systemName: "tray.circle")
                        .renderingMode(.template)
                    
                    Text(Constants.card)
                }
            
            RouteView()
                .tabItem {
                    Image(systemName: "mappin.square")
                        .renderingMode(.template)
                    
                    Text(Constants.route)
                }
            
            AboutView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                        .renderingMode(.template)
                    
                    Text(Constants.about)
                }
        }
        .accentColor(AppColor.Components.TabBar.tint)
    }
}

extension TabedView {
    struct Constants {
        static let start = "Start"
        static let mode = "Trafikläget"
        static let card = "kort information"
        static let route = "Tunnelbana Karta"
        static let about = "Om"
    }
}


struct TabedView_Previews: PreviewProvider {
    static var previews: some View {
        TabedView()
    }
}
