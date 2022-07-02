//
//  CardView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        NavigationView {
            Text(Constants.title)
                .navigationTitle(Constants.title)
        }
    }
}

extension CardView {
    struct Constants {
        static let title = "kort information"
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
