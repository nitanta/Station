//
//  Calendar.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Calendar: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Calendar> {
        return NSFetchRequest<Calendar>(entityName: "Calendar")
    }
    
    @NSManaged var service_id: String?
    @NSManaged var monday: String?
    @NSManaged var tuesday: String?
    @NSManaged var wednesday: String?
    @NSManaged var thursday: String?
    @NSManaged var friday: String?
    @NSManaged var saturday: String?
    @NSManaged var sunday: String?
    @NSManaged var start_date: String?
    @NSManaged var end_date: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Calendar", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .service_id)
                
        service_id = id
        monday = try values.decodeIfPresent(String.self, forKey: .monday)
        tuesday = try values.decodeIfPresent(String.self, forKey: .tuesday)
        wednesday = try values.decodeIfPresent(String.self, forKey: .wednesday)
        thursday = try values.decodeIfPresent(String.self, forKey: .thursday)
        friday = try values.decodeIfPresent(String.self, forKey: .friday)
        saturday = try values.decodeIfPresent(String.self, forKey: .saturday)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date
    }
    
}
