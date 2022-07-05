//
//  TrafficDataManager.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 04/07/2022.
//

import Foundation
import os.log

class TrafficDataManager {
    let logger = Logger(subsystem: "StationMaster", category: "main")
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func callTripUpdateAPI(completion: ((Result<TransitRealtime_FeedMessage, Error>) -> ())? = nil) {
        let path = Global.baseURL + "/gtfs-rt/\(Global.operatorr)/TripUpdates.pb?key=\(Global.realtimeAPIKey)"
        
        let session = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            if let error = error {
                completion?(.failure(error))
            }
            if let data = data {
                guard let update = try? TransitRealtime_FeedMessage(serializedData: data) else { return }
                self.logger.info("Trip Update Fetch Task complete")
                completion?(.success(update))
            }
        }
        session.resume()
    }
    
    func callServiceAlertsAPI(completion: ((Result<TransitRealtime_FeedMessage, Error>) -> ())? = nil) {
        let path = Global.baseURL + "/gtfs-rt/\(Global.operatorr)/ServiceAlerts.pb?key=\(Global.realtimeAPIKey)"
        
        let session = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            if let error = error {
                completion?(.failure(error))
            }
            if let data = data {
                guard let alert = try? TransitRealtime_FeedMessage(serializedData: data) else { return }
                self.logger.info("Alert Task complete")
                completion?(.success(alert))
            }
        }
        session.resume()
    }
    
    func callVehiclePositionsAPI(completion: ((Result<TransitRealtime_FeedMessage, Error>) -> ())? = nil) {
        let path = Global.baseURL + "/gtfs-rt/\(Global.operatorr)/VehiclePositions.pb?key=\(Global.realtimeAPIKey)"
        
        let session = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            if let error = error {
                completion?(.failure(error))
            }
            if let data = data {
                guard let vehicle = try? TransitRealtime_FeedMessage(serializedData: data) else { return }
                self.logger.info("Position Task complete")
                completion?(.success(vehicle))
            }
        }
        session.resume()
    }
    
}
