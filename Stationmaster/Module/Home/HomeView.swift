//
//  HomeView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct HomeView: View {
    @State var seaarch: String = ""
    var datasource: [StationData] = [
        StationData(stationIcon: .camera, stationLocation: "Hägerstensåsen", stationCode: "23", status: .green, trains: [
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
        ]),
    ]
    
    var body: some View {
        ScrollView {
            listingView
                .searchable(text: $seaarch)
                .padding()
        }
        .navigationTitle(Constants.title)
    }
    
    private var listingView: some View {
        ForEach(datasource, id: \.self) { source in
            Section(header: Header(data: source)) {
                ForEach(source.trains, id: \.self) { train in
                    Text(train.name)
                }
            }
        }
    }
    
    struct Header: View {
        let data: StationData
        
        var body: some View {
            HStack {
                HStack {
                    Rectangle()
                        .frame(width: 10)
                        .foregroundColor(.orange)
                    
                    VStack {
                        Text(Constants.code)
                        Text(data.stationCode)
                    }
                    .background(.gray)
                }
                
                Spacer()
                
                Text(data.stationLocation)
                
                Spacer()
                
                HStack {
                    VStack {
                        Image(systemName: data.stationIcon.rawValue)
                        
                    }
                    .background(.gray)
                    
                    Rectangle()
                        .frame(width: 10)
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

extension HomeView {
    struct Constants {
        static let title = "Start"
        static let code = "Code"
    }
}

enum StatusType {
    case red
    case green
    case blue
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
}

enum IconType: String {
    case camera = "camera.circle"
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
