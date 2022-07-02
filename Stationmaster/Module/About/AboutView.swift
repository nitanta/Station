//
//  AboutView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Text(Constants.title)
            .navigationTitle(Constants.title)
    }
}

extension AboutView {
    struct Constants {
        static let title = "Om"
    }
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
