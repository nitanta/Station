//
//  Stops.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Stops: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Stops> {
        return NSFetchRequest<Stops>(entityName: "Stops")
    }
    
    @NSManaged var stop_id: String?
    @NSManaged var stop_name: String?
    @NSManaged var stop_lat: String?
    @NSManaged var stop_lon: String?
    @NSManaged var location_type: String?
    @NSManaged var parent_station: String?
    @NSManaged var platform_code: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Stops", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .stop_id)
                
        stop_id = id
        stop_name = try values.decodeIfPresent(String.self, forKey: .stop_name)
        stop_lat = try values.decodeIfPresent(String.self, forKey: .stop_lat)
        stop_lon = try values.decodeIfPresent(String.self, forKey: .stop_lon)
        location_type = try values.decodeIfPresent(String.self, forKey: .location_type)
        parent_station = try values.decodeIfPresent(String.self, forKey: .parent_station)
        platform_code = try values.decodeIfPresent(String.self, forKey: .platform_code)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case stop_id, stop_name, stop_lat, stop_lon, location_type, parent_station, platform_code
    }
    
}
