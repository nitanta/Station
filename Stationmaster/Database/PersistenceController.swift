//
//  PersistenceController.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 05/07/2022.
//

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.managedObjectContext
        MockHelper.addMockdataForPreview(in: viewContext)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "StationMaster")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteData() {
        let manager = PersistenceController.shared
        manager.clearEntities(entities: [
            String(describing: Trips.self),
            String(describing: Agency.self),
            String(describing: Attributions.self),
            String(describing: Calendardates.self),
            String(describing: Calendar.self),
            String(describing: Feedinfo.self),
            String(describing: Routes.self),
            String(describing: Shapes.self),
            String(describing: Stoptimes.self),
            String(describing: Stops.self),
            String(describing: Transfers.self),
        ])
    }
    
    
    private func clearEntities(entities: [String]) {
        let context = PersistenceController.shared.managedObjectContext
        context.perform {
            do {
                try entities.forEach { (entityName) in
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
                    let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try context.execute(request)
                }
                try context.save()
            } catch {
                assertionFailure("Cannot perform delete \(error)")
            }
        }
    }
}
