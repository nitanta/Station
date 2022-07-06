//
//  Calendardates.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Calendardates: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Calendardates> {
        return NSFetchRequest<Calendardates>(entityName: "Calendardates")
    }
    
    @NSManaged var service_id: String?
    @NSManaged var date: String?
    @NSManaged var exception_type: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Calendardates", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .service_id)
                
        service_id = id
        date = try values.decodeIfPresent(String.self, forKey: .date)
        exception_type = try values.decodeIfPresent(String.self, forKey: .exception_type)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case service_id, date, exception_type
    }
    
}
