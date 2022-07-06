//
//  Agency.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Attributions: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Attributions> {
        return NSFetchRequest<Attributions>(entityName: "Attributions")
    }
    
    @NSManaged var trip_id: String?
    @NSManaged var organization_name: String?
    @NSManaged var is_operator: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Attributions", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .trip_id)
                
        trip_id = id
        organization_name = try values.decodeIfPresent(String.self, forKey: .organization_name)
        is_operator = try values.decodeIfPresent(String.self, forKey: .is_operator)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case trip_id, organization_name, is_operator
    }
    
}
