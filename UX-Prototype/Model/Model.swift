//
//  Model.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/3/23.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Replace with your model name
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}
