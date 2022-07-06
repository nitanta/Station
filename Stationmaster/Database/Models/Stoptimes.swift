//
//  Stoptimes.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Stoptimes: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Stoptimes> {
        return NSFetchRequest<Stoptimes>(entityName: "Stoptimes")
    }
    
    @NSManaged var trip_id: String?
    @NSManaged var arrival_time: String?
    @NSManaged var departure_time: String?
    @NSManaged var stop_id: String?
    @NSManaged var stop_sequence: String?
    @NSManaged var stop_headsign: String?
    @NSManaged var pickup_type: String?
    @NSManaged var drop_off_type: String?
    @NSManaged var shape_dist_traveled: String?
    @NSManaged var timepoint: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Stoptimes", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .trip_id)
                
        trip_id = id
        arrival_time = try values.decodeIfPresent(String.self, forKey: .arrival_time)
        departure_time = try values.decodeIfPresent(String.self, forKey: .departure_time)
        stop_id = try values.decodeIfPresent(String.self, forKey: .stop_id)
        stop_headsign = try values.decodeIfPresent(String.self, forKey: .stop_headsign)
        pickup_type = try values.decodeIfPresent(String.self, forKey: .pickup_type)
        drop_off_type = try values.decodeIfPresent(String.self, forKey: .drop_off_type)
        shape_dist_traveled = try values.decodeIfPresent(String.self, forKey: .shape_dist_traveled)
        timepoint = try values.decodeIfPresent(String.self, forKey: .timepoint)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case trip_id, arrival_time, departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint
    }
    
}
