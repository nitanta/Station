//
//  ModeView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct ModeView: View {
    var body: some View {
        NavigationView {
            Text(Constants.title)
                .navigationTitle(Constants.title)
        }
    }
}

extension ModeView {
    struct Constants {
        static let title = "Trafikläget"
    }
}


struct ModeView_Previews: PreviewProvider {
    static var previews: some View {
        ModeView()
    }
}
