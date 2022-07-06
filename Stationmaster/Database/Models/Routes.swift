//
//  Routes.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Routes: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Routes> {
        return NSFetchRequest<Routes>(entityName: "Routes")
    }
    
    @NSManaged var route_id: String?
    @NSManaged var agency_id: String?
    @NSManaged var route_short_name: String?
    @NSManaged var route_long_name: String?
    @NSManaged var route_type: String?
    @NSManaged var route_desc: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Routes", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .route_id)
                
        route_id = id
        agency_id = try values.decodeIfPresent(String.self, forKey: .agency_id)
        route_short_name = try values.decodeIfPresent(String.self, forKey: .route_short_name)
        route_long_name = try values.decodeIfPresent(String.self, forKey: .route_long_name)
        route_type = try values.decodeIfPresent(String.self, forKey: .route_type)
        route_desc = try values.decodeIfPresent(String.self, forKey: .route_desc)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case route_id, agency_id, route_short_name, route_long_name, route_type, route_desc
    }
    
}
