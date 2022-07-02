//
//  RouteView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct RouteView: View {
    var body: some View {
        Text(Constants.title)
            .navigationTitle(Constants.title)
    }
}

extension RouteView {
    struct Constants {
        static let title = "Tunnelbana Karta"
    }
}


struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}
