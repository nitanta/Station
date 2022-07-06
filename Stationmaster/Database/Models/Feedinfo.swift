//
//  Feedinfo.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import CoreData

class Feedinfo: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Feedinfo> {
        return NSFetchRequest<Feedinfo>(entityName: "Feedinfo")
    }
    
    @NSManaged var feed_id: String?
    @NSManaged var feed_publisher_name: String?
    @NSManaged var feed_publisher_url: String?
    @NSManaged var feed_lang: String?
    @NSManaged var feed_version: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        let context = PersistenceController.shared.managedObjectContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Feedinfo", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .feed_id)
                
        feed_id = id
        feed_publisher_name = try values.decodeIfPresent(String.self, forKey: .feed_publisher_name)
        feed_publisher_url = try values.decodeIfPresent(String.self, forKey: .feed_publisher_url)
        feed_lang = try values.decodeIfPresent(String.self, forKey: .feed_lang)
        feed_version = try values.decodeIfPresent(String.self, forKey: .feed_version)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case feed_id, feed_publisher_name, feed_publisher_url, feed_lang, feed_version
    }
    
}
