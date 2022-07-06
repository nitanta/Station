//
//  HomeViewModel.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 04/07/2022.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    
    @Published var error: AppAlert?
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
    }
    
    deinit {
        debugPrint("Deint: \(String(describing: self))")
    }
}

extension HomeViewModel {
    struct Constants {
        static let ok = "OKAY"
        static let cancel = "CANCEL"
    }
}
