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
        StationData(name: "Hägerstensåsen", isStarred: true, message: "Elevator under maintainance", areaType: .red, destinations: [
            Board(fromName: "Fruängen", toName: "T-Centralen - Mörby centrum", platfrom: "1", icon: .camera, trains: [
                TrainData(name: "Mörby centrum", number: "14", time: "12:25 PM", arrivingIn: "5 mins"),
                TrainData(name: "Mörby centrum", number: "14", time: "12:30 PM", arrivingIn: "10 mins"),
                TrainData(name: "Mörby centrum", number: "14", time: "12:35 PM", arrivingIn: "15 mins")
            ]),
            Board(fromName: "T-Centralen - Mörby centrum", toName: "Fruängen", platfrom: "2", icon: .camera, trains: [
                TrainData(name: "Fruängen", number: "14", time: "12:30 PM", arrivingIn: "10 mins"),
                TrainData(name: "Fruängen", number: "14", time: "12:40 PM", arrivingIn: "20 mins"),
                TrainData(name: "Fruängen", number: "14", time: "12:50 PM", arrivingIn: "30 mins")
            ])
        ]),
        
        StationData(name: "Stureby", isStarred: true, message: "Lift is not working nicely", areaType: .green, destinations: [
            Board(fromName: "Hagsätra", toName: "T-Centralen - Hässelby strand", platfrom: "1", icon: .camera, trains: [
                TrainData(name: "Hässelby strand", number: "19", time: "12:30 PM", arrivingIn: "10 mins"),
                TrainData(name: "Hässelby strand", number: "19", time: "12:40 PM", arrivingIn: "20 mins"),
                TrainData(name: "Hässelby strand", number: "19", time: "12:50 PM", arrivingIn: "30 mins")
            ]),
            Board(fromName: "T-Centralen - Hässelby strand", toName: "Hagsätra", platfrom: "2", icon: .camera, trains: [
                TrainData(name: "Hagsätra", number: "19", time: "12:35 PM", arrivingIn: "15 mins"),
                TrainData(name: "Hagsätra", number: "19", time: "12:45 PM", arrivingIn: "25 mins"),
                TrainData(name: "Hagsätra", number: "19", time: "12:55 PM", arrivingIn: "35 mins")
            ])
        ])
        
    ]
    
    @StateObject var viewModel = HomeViewModel()
    
    init() {}
    
    var body: some View {
        NavigationView {
            ScrollView {
                listingView
                    .searchable(text: $seaarch, placement: .navigationBarDrawer(displayMode: .always))
                    .padding()
            }
            .navigationTitle(Constants.title)
        }
    }
    
    private var listingView: some View {
        ForEach(datasource, id: \.self) { source in
            Section(header: Header(data: source)) {
                ForEach(source.destinations, id: \.self) { board in
                    ListCell(data: board, areaType: source.areaType, message: source.message)
                }
            }
        }
    }
    
    struct Header: View {
        let data: StationData
        
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .foregroundColor(data.areaType.color)
                    
                    Text(data.areaType.rawValue)
                        .font(AppFont.proRegular16)
                        .foregroundColor(data.areaType.color)
                    
                }
                
                Spacer()
                
                Text(data.name)
                    .font(AppFont.proRegular18)
                
                Spacer()
                
                
                Image(systemName: data.isStarred ? "star.fill" : "star")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 16, height: 16)
                    .foregroundColor(data.isStarred ? AppColor.orange : AppColor.gray)
                
            }
        }
    }
    
    struct ListCell: View {
        let data: Board
        let areaType: AreaType
        let message: String
        
        @State var duration: Double = 5.0
        @State var autoreverses: Bool = false

        var body: some View {
            VStack {
                CellHeader(data: data, areaType: areaType)
                
                ZStack {
                    DotBackground()
                    
                    VStack {
                        if let row = constructFirstRow() {
                            TrainFirstCell(data: row)
                                .frame(height: 26)
                        }
                        
                        Marquee {
                            TrainSecondCell(data: constructSecondRow())
                        }
                        .marqueeDuration(duration)
                        .marqueeAutoreverses(autoreverses)
                        .frame(height: 26)
                    }
                    .padding()
                }
            }
            .padding(.bottom, 40)
        }
        
        func constructFirstRow() -> TrainData? {
            if let firstTrain = data.trains.first {
                return firstTrain
            }
            return nil
        }
        
        func constructSecondRow() -> String {
            let trainData = data.trains
            
            let remainigTrains = Array(trainData.dropFirst())
            
            var secondRowString: String = ""
            
            remainigTrains.forEach { data in
                secondRowString += "\(data.number) \t \(data.name) \t \(data.arrivingIn) \t"
            }
            if !message.isEmpty {
                secondRowString += "\t \(message)"
            }
            
            return secondRowString
        }
                
    }
    
    struct DotBackground: View {
        let rows = [GridItem](repeating: GridItem(.flexible()), count: 1)
        
        var body: some View {
            GeometryReader { proxy in
                
                LazyHGrid(rows: rows, content: {
                    ForEach((1 ..< Int(proxy.size.width / 1.5)), id: \.self) { item in
                        Circle()
                            .frame(width: 1, height: 1)
                            .foregroundColor(.gray)
                    }
                })
            }
            .background(.black.opacity(0.8))
        }
    }
    
    struct CellHeader: View {
        let data: Board
        let areaType: AreaType
        
        var body: some View {
            VStack(spacing: 4) {
                Rectangle()
                    .foregroundColor(AppColor.gray)
                    .frame(height: 8)
                
                HStack {
                    HStack(spacing: 4) {
                        Rectangle()
                            .frame(width: 10)
                            .foregroundColor(areaType.color)
                        
                        VStack {
                            Text(Constants.track)
                                .font(AppFont.proRegular10)
                                .foregroundColor(AppColor.white)
                            
                            Text(data.platfrom)
                                .font(AppFont.proRegular14)
                                .foregroundColor(AppColor.white)

                        }
                        .padding(10)
                        .background(AppColor.black)
                    }
                    
                    Spacer()
                    
                    Text(Constants.title + data.toName)
                        .font(AppFont.proRegular18)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        VStack {
                            
                            Image(data.icon.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundColor(AppColor.white)
                                .padding(8)
                            
                        }
                        .background(AppColor.black)

                        Rectangle()
                            .frame(width: 10)
                            .foregroundColor(areaType.color)
                    }
                }
            }
        }
        
        struct Constants {
            static let track = "Spår"
            static let title = "Tåg mot "
        }
    }
    
    struct TrainSecondCell: View {
        let data: String
        
        var body: some View {
            HStack {
                Text(data)
                    .font(AppFont.proSemibold24)
                    .foregroundColor(.orange)
            }
        }
    }
    
    struct TrainFirstCell: View {
        let data: TrainData
        var body: some View {
            HStack {
                Text(data.number)
                    .font(AppFont.proSemibold24)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Text(data.name)
                    .font(AppFont.proSemibold24)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Text(data.arrivingIn)
                    .font(AppFont.proSemibold24)
                    .foregroundColor(.orange)
            }
        }
    }
}

extension HomeView {
    struct Constants {
        static let title = "Start"
    }
}

enum AreaType: String {
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    
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
    case camera = "icon_cctv"
}

struct StationData: Hashable {
    var name: String
    var isStarred: Bool
    var message: String
    var areaType: AreaType
    var destinations: [Board]
}

struct Board: Hashable {
    var fromName: String
    var toName: String
    var platfrom: String
    var icon: IconType
    var trains: [TrainData]
}

struct TrainData: Hashable {
    var name: String
    var number: String
    var time: String
    var arrivingIn: String
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
