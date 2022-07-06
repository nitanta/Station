//
//  Agency.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Agency: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Agency> {
        return NSFetchRequest<Agency>(entityName: "Agency")
    }
    
    @NSManaged var agency_id: String?
    @NSManaged var agency_name: String?
    @NSManaged var agency_url: String?
    @NSManaged var agency_timezone: String?
    @NSManaged var agency_lang: String?
    @NSManaged var agency_fare_url: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Agency", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .agency_id)
                
        agency_id = id
        agency_name = try values.decodeIfPresent(String.self, forKey: .agency_name)
        agency_url = try values.decodeIfPresent(String.self, forKey: .agency_url)
        agency_timezone = try values.decodeIfPresent(String.self, forKey: .agency_timezone)
        agency_lang = try values.decodeIfPresent(String.self, forKey: .agency_lang)
        agency_fare_url = try values.decodeIfPresent(String.self, forKey: .agency_fare_url)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_fare_url
    }
    
}
