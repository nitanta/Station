//
//  Shapes.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Shapes: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Shapes> {
        return NSFetchRequest<Shapes>(entityName: "Shapes")
    }
    
    @NSManaged var shape_id: String?
    @NSManaged var shape_pt_lat: String?
    @NSManaged var shape_pt_lon: String?
    @NSManaged var shape_pt_sequence: String?
    @NSManaged var shape_dist_traveled: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Shapes", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .shape_id)
                
        shape_id = id
        shape_pt_lat = try values.decodeIfPresent(String.self, forKey: .shape_pt_lat)
        shape_pt_lon = try values.decodeIfPresent(String.self, forKey: .shape_pt_lon)
        shape_pt_sequence = try values.decodeIfPresent(String.self, forKey: .shape_pt_sequence)
        shape_dist_traveled = try values.decodeIfPresent(String.self, forKey: .shape_dist_traveled)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, shape_dist_traveled
    }
    
}
