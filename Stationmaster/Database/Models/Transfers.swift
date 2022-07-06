//
//  Transfers.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Transfers: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Transfers> {
        return NSFetchRequest<Transfers>(entityName: "Transfers")
    }
    
    @NSManaged var from_stop_id: String?
    @NSManaged var to_stop_id: String?
    @NSManaged var transfer_type: String?
    @NSManaged var min_transfer_time: String?
    @NSManaged var from_trip_id: String?
    @NSManaged var to_trip_id: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Transfers", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .from_stop_id)
                
        from_stop_id = id
        to_stop_id = try values.decodeIfPresent(String.self, forKey: .to_stop_id)
        transfer_type = try values.decodeIfPresent(String.self, forKey: .transfer_type)
        min_transfer_time = try values.decodeIfPresent(String.self, forKey: .min_transfer_time)
        from_trip_id = try values.decodeIfPresent(String.self, forKey: .from_trip_id)
        to_trip_id = try values.decodeIfPresent(String.self, forKey: .to_trip_id)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case from_stop_id, to_stop_id, transfer_type, min_transfer_time, from_trip_id, to_trip_id
    }
    
}
