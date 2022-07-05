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
    
    let downloadManager = DatasetDownloadManager()
    let dataManager = TrafficDataManager()
    
    init() {
        dataManager.callTripUpdateAPI()
        dataManager.callServiceAlertsAPI()
        dataManager.callVehiclePositionsAPI()
        downloadManager.startDownload()
    }
    
    deinit {
        debugPrint("Deint: \(String(describing: self))")
    }
    
    func callTripUpdateAPI() {
        let path = Global.baseURL + "/gtfs-rt/\(Global.operatorr)/TripUpdates.pb?key=\(Global.realtimeAPIKey)"
        
        let session = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            if let error = error {
                debugPrint("Error", error.localizedDescription)
            }
            if let data = data {
                guard let update = try? TransitRealtime_TripUpdate(serializedData: data) else { return }
                print("Update", update)
            }
        }
        session.resume()
    }
    
    func callServiceAlertsAPI() {
        let path = Global.baseURL + "/gtfs-rt/\(Global.operatorr)/ServiceAlerts.pb?key=\(Global.realtimeAPIKey)"
        
        let session = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            if let error = error {
                debugPrint("Error", error.localizedDescription)
            }
            if let data = data {
                guard let alert = try? TransitRealtime_Alert(serializedData: data) else { return }
                print("Data", alert)
            }
        }
        session.resume()
    }
    
    func callVehiclePositionsAPI() {
        let path = Global.baseURL + "/gtfs-rt/\(Global.operatorr)/VehiclePositions.pb?key=\(Global.realtimeAPIKey)"
        
        let session = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            if let error = error {
                debugPrint("Error", error.localizedDescription)
                self.error = AppAlert(type: .error(error), actions: [
                    AlertAction(action: nil, title: Constants.ok)
                ])
                self.showError = true
            }
            if let data = data {
                guard let vehicle = try? TransitRealtime_VehiclePosition(serializedData: data) else { return }
                print("Data", vehicle)
            }
        }
        session.resume()
    }
}

extension HomeViewModel {
    struct Constants {
        static let ok = "OKAY"
        static let cancel = "CANCEL"
    }
}
