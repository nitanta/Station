//
//  TabedViewModel.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import SwiftUI
import Combine

final class TabedViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    
    @Published var error: AppAlert?
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
    let downloadManager = DatasetDownloadManager()
    let dataManager = TrafficDataManager()
    let adder = DatasetAdderManager()
    let cleaner = DatasetCleanerManager()
    
    init() {
//        dataManager.callTripUpdateAPI()
//        dataManager.callServiceAlertsAPI()
//        dataManager.callVehiclePositionsAPI()
//        downloadManager.startDownload()
        
        let cleanInterval = TimeInterval(10 * 60)//TimeInterval(24 * 24 * 60 * 60)
        let cleanupDate = Date().addingTimeInterval(-cleanInterval)
        
        let lastFetchDate = UserDefaults.standard.value(forKey: UserDefaultsKey.datefetchdate) as? Date
        
        if lastFetchDate == nil, let fetchDate = lastFetchDate, fetchDate <  cleanupDate {
            isLoading.toggle()
            adder.addDataset { [weak self] in
                guard let self = self else { return }
                self.cleaner.cleanDataset(before: cleanupDate) {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
            }
        }
        
    }
    
    deinit {
        debugPrint("Deint: \(String(describing: self))")
    }
}

extension TabedViewModel {
    struct Constants {
        static let ok = "OKAY"
        static let cancel = "CANCEL"
    }
}
