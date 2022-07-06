//
//  MockHelper.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 05/07/2022.
//

import Foundation
import CoreData

struct MockHelper {
    
    static func addMockdataForPreview(in context: NSManagedObjectContext) {
        _ = Trips.saveTrip("0", routeId: "0", serviceId: "0", tripHeadsign: "0", directionId: "0", shapeId: "0")
    }
    
    static func parseJSONFile<T: Codable>(_ filename: String, type: T.Type) -> T? {
        guard let path = Bundle.main.url(forResource: filename, withExtension: "json") else { return nil }
        
        if let data = try? Data(contentsOf: path), let parsed = try? JSONDecoder().decode(T.self, from: data) {
            return parsed
        }
        return nil
    }
}
