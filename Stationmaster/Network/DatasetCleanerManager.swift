//
//  DatasetCleanerManager.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation
import os.log
import CoreData

class LoggableManager {
    let logger = Logger(subsystem: "StationMaster", category: "main")
    let persistenceController = PersistenceController.shared
    
    init() {}
}

class DatasetCleanerManager: LoggableManager {

    override init() {
        super.init()
    }
    
    func cleanDataset(before: Date, completion: (() -> ())? = nil) {
        
        let datatypes = DatasetType.allCases
        
        datatypes.forEach { type in
            let predicate = NSPredicate(format: "updated_date <= %@", before as CVarArg)
            switch type {
            case .trips:
                delete(Trips.self, predicate: predicate)
            case .transfer:
                delete(Transfers.self, predicate: predicate)
            case .stops:
                delete(Stops.self, predicate: predicate)
            case .stopstimes:
                delete(Stoptimes.self, predicate: predicate)
            case .shapes:
                delete(Shapes.self, predicate: predicate)
            case .routes:
                delete(Routes.self, predicate: predicate)
            case .feedinfo:
                delete(Feedinfo.self, predicate: predicate)
            case .calendar:
                delete(Calendar.self, predicate: predicate)
            case .calendardates:
                delete(Calendardates.self, predicate: predicate)
            case .attributions:
                delete(Attributions.self, predicate: predicate)
            case .agency:
                delete(Agency.self, predicate: predicate)
            }
        }
        completion?()
    }
    
    private func delete<T: NSManagedObject >(_ type: T.Type, predicate: NSPredicate?) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: type))
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let context = persistenceController.managedObjectContext
        let batchDelete = try? context.execute(deleteRequest) as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else { return }
        let deletedObjects: [AnyHashable: Any] = [ NSDeletedObjectsKey: deleteResult ]
        
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
    }
}
