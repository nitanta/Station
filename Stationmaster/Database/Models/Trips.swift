//
//  Trip.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 05/07/2022.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

class Trips: NSManagedObject, DatabaseManageable, Decodable {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Trips> {
        return NSFetchRequest<Trips>(entityName: "Trips")
    }
    
    @NSManaged var route_id: String?
    @NSManaged var service_id: String?
    @NSManaged var trip_id: String?
    @NSManaged var trip_headsign: String?
    @NSManaged var direction_id: String?
    @NSManaged var shape_id: String?
    @NSManaged var updated_date: Date?
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
            fatalError("Decode failure")
        }
        guard  let entity = NSEntityDescription.entity(forEntityName: "Trips", in: context) else {
            fatalError("Decode failure")
        }
        
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decodeIfPresent(String.self, forKey: .trip_id)
                
        trip_id = id
        route_id = try values.decodeIfPresent(String.self, forKey: .route_id)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        trip_headsign = try values.decodeIfPresent(String.self, forKey: .trip_headsign)
        direction_id = try values.decodeIfPresent(String.self, forKey: .direction_id)
        shape_id = try values.decodeIfPresent(String.self, forKey: .shape_id)
        updated_date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case route_id, service_id, trip_id, trip_headsign, direction_id, shape_id
    }
    
    
    static func saveTrip(_ tripId: String, routeId: String, serviceId: String, tripHeadsign: String, directionId: String, shapeId: String) -> Trips {
        let localTrip: Trips!
        if let trip = findFirst(predicate: NSPredicate(format: "trip_id == %@", tripId), type: Trips.self) {
            localTrip = trip
        } else {
            localTrip = Trips(context: PersistenceController.shared.managedObjectContext)
        }
        
        localTrip.route_id = routeId
        localTrip.service_id = serviceId
        localTrip.trip_id = tripId
        localTrip.trip_headsign = tripHeadsign
        localTrip.direction_id = directionId
        localTrip.shape_id = shapeId
        
        
        return localTrip
    }
    
    //    static func removeUser(_ id: String) {
    //        if let movie = findFirst(predicate: NSPredicate(format: "id == %@", id), type: User.self) {
    //            PersistenceController.shared.managedObjectContext.delete(movie)
    //        }
    //    }
    
}
