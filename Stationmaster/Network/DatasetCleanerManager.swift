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
        let context = persistenceController.backgroundContet
        
        context.perform { [weak self, weak context] in
            guard let self = self, let context = context else { return }
            
            let types = DatasetType.allCases
            
            types.forEach { type in
                let predicate = NSPredicate(format: "updated_date <= %@", before as CVarArg)
                switch type {
                case .trips:
                    self.delete(Trips.self, context: context, predicate: predicate)
                case .transfer:
                    self.delete(Transfers.self, context: context, predicate: predicate)
                case .stops:
                    self.delete(Stops.self, context: context, predicate: predicate)
                case .stopstimes:
                    self.delete(Stoptimes.self, context: context, predicate: predicate)
                case .shapes:
                    self.delete(Shapes.self, context: context, predicate: predicate)
                case .routes:
                    self.delete(Routes.self, context: context, predicate: predicate)
                case .feedinfo:
                    self.delete(Feedinfo.self, context: context, predicate: predicate)
                case .calendar:
                    self.delete(Calendar.self, context: context, predicate: predicate)
                case .calendardates:
                    self.delete(Calendardates.self, context: context, predicate: predicate)
                case .attributions:
                    self.delete(Attributions.self, context: context, predicate: predicate)
                case .agency:
                    self.delete(Agency.self, context: context, predicate: predicate)
                }
            }
            
            try? context.save()
            
            completion?()
        }
    }
    
    
    private func delete<T: NSManagedObject >(_ type: T.Type, context: NSManagedObjectContext, predicate: NSPredicate?) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: type))
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let batchDelete = try? context.execute(deleteRequest) as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else { return }
        let deletedObjects: [AnyHashable: Any] = [ NSDeletedObjectsKey: deleteResult ]
        
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
    }
}
