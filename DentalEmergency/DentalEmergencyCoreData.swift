//
//  DentalEmergencyCoreData.swift
//  DentalEmergency
//
//  Created by Lisue She on 8/8/17.
//
//

import Foundation
import CoreData

enum EntityType {
    case selectedOffice, textSearch, detailSearch, photoReference
}


class DentalEmergencyDataCore: NSObject, NSFetchedResultsControllerDelegate {
   
    var entityName: String = ""
    var sortDescriptor: [NSSortDescriptor]?
    
    func setEntityProperty ( entityType: EntityType, context: NSManagedObjectContext )  {
        
        switch entityType {
            case EntityType.selectedOffice:
                entityName = "MySelectedOffices"
                sortDescriptor = [NSSortDescriptor(key: "name", ascending: true),
                                  NSSortDescriptor(key: "placeId", ascending: false),
                                  NSSortDescriptor(key: "rating", ascending: false),
                                  NSSortDescriptor(key: "latitude", ascending: false),
                                  NSSortDescriptor(key: "longitude", ascending: false)]
            default:
                entityName = "MySelectedOffices"
                sortDescriptor = [NSSortDescriptor(key: "name", ascending: true),
                                  NSSortDescriptor(key: "placeId", ascending: false),
                                  NSSortDescriptor(key: "rating", ascending: false),
                                  NSSortDescriptor(key: "latitude", ascending: false),
                                  NSSortDescriptor(key: "longitude", ascending: false)]
        }
    }
    
    func initFetchResultsController( entityType: EntityType, context: NSManagedObjectContext?, predicate: NSPredicate? ) -> NSFetchedResultsController<NSFetchRequestResult>{
        
        setEntityProperty ( entityType: entityType, context: context! )
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        // Add Sort Descriptors
        if let myDescriptor = sortDescriptor {
          fetchRequest.sortDescriptors = myDescriptor
        }
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        return fetchedResultsController
    }
}
