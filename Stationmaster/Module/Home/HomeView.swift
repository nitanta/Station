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
        StationData(isStarred: true, location: "Hägerstensåsen", from: "Tag mot fraugen", stationIcon: .camera, stationCode: "23", status: .red, trains: [
            TrainData(name: "Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
        ]),
        StationData(isStarred: false, location: "Hägerstensåsen", from: "Tag mot fraugen", stationIcon: .camera, stationCode: "25", status: .green, trains: [
            TrainData(name: "Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
            TrainData(name: "Mørby Centrum", number: "14", time: "13 min"),
        ]),
    ]
    
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
                ListCell(data: source)
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
                        .foregroundColor(data.status.color)
                    
                    Text(data.status.rawValue)
                        .font(AppFont.proRegular16)
                        .foregroundColor(data.status.color)
                    
                }
                
                Spacer()
                
                Text(data.location)
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
        let data: StationData
        var body: some View {
            VStack {
                CellHeader(data: data)
                
                ZStack {
                    DotBackground()
                    
                    VStack {
                        ForEach(data.trains, id: \.self) { train in
                            Marquee {
                                TrainListCell(data: train)
                            }
                            .frame(height: 30)
                        }
                    }
                    .padding()
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    struct DotBackground: View {
        let rows = [GridItem](repeating: GridItem(.flexible()), count: 6)
        
        var body: some View {
            GeometryReader { proxy in
                
                LazyHGrid(rows: rows, content: {
                    ForEach((1 ..< Int(proxy.size.width / 1.5)), id: \.self) { item in
                        Circle()
                            .frame(width: 1, height: 1)
                            .foregroundColor(.gray)
                    }
                })
                .background(.black.opacity(0.8))
            }
        }
    }
    
    struct CellHeader: View {
        let data: StationData
        
        var body: some View {
            VStack(spacing: 4) {
                Rectangle()
                    .foregroundColor(AppColor.gray)
                    .frame(height: 8)
                
                HStack {
                    HStack(spacing: 4) {
                        Rectangle()
                            .frame(width: 10)
                            .foregroundColor(.orange)
                        
                        VStack {
                            Text(Constants.code)
                                .font(AppFont.proRegular10)
                                .foregroundColor(AppColor.white)
                            
                            Text(data.stationCode)
                                .font(AppFont.proRegular14)
                                .foregroundColor(AppColor.white)

                        }
                        .padding(10)
                        .background(AppColor.black)
                    }
                    
                    Spacer()
                    
                    Text(data.from)
                        .font(AppFont.proRegular18)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        VStack {
                            
                            Image(data.stationIcon.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundColor(AppColor.white)
                                .padding(8)
                            
                        }
                        .background(AppColor.black)

                        Rectangle()
                            .frame(width: 10)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        
        struct Constants {
            static let code = "Code"
        }
    }
    
    struct TrainListCell: View {
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
                
                Text(data.time)
                    .font(AppFont.proSemibold24)
                    .foregroundColor(.orange)
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

enum StatusType: String {
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
    var isStarred: Bool
    var location: String
    var from: String
    var stationIcon: IconType
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
