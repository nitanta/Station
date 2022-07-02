//
//  HomeView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct HomeView: View {
    
    var datasource: [StationData] = [
        StationData(stationIcon: .camera, stationLocation: "Hägerstensåsen", stationCode: "23", status: .green, trains: [
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min")
        ]),
        StationData(stationIcon: .camera, stationLocation: "Hägerstensåsen", stationCode: "23", status: .green, trains: [
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min")
        ])
    ]
    
    var body: some View {
        listingView
            .padding()
            .navigationTitle(Constants.title)
    }
    
    private var listingView: some View {
        List(datasource, id: \.self) { source in
            Section(header: Text(source.stationLocation)) {
                List(source.trains, id: \.self) { train in
                    Text("\(train.name) by \(train.number)")
                }
            }
        }
    }
}

extension HomeView {
    struct Constants {
        static let title = "Start"
    }
}

enum StatusType {
    case red
    case green
    case bluw
}

enum IconType {
    case camera
}

struct StationData: Hashable {
    var stationIcon: IconType
    var stationLocation: String
    var stationCode: String
    var status: StatusType
    var trains: [TrainData]
}

struct TrainData: Hashable {
    var name: String
    var number: String
    var time: String
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
