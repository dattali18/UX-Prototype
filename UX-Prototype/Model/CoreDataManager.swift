//
//  CoreDataManager.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/5/23.
//

import Foundation
import CoreData

class CoreDataManager {
    private static let Shared = CoreDataManager()

    static var shared: CoreDataManager {
      return Shared
    }
    // MARK: - CRUD Operations
    let managedObjectContext = CoreDataStack.shared.managedObjectContext

    // Create
    func create<T: NSManagedObject>(entity: T.Type, with parameters: [String: Any]) -> T? {
        let newEntity = entity.init(context: managedObjectContext)

          for (key, value) in parameters {
            newEntity.setValue(value, forKey: key)
          }

          do {
            try managedObjectContext.save()
            return newEntity
          } catch {
            print("Error creating entity: \(error)")
            return nil
      }
    }

    // Fetch
    func fetch<T: NSManagedObject>(entity: T.Type, with parameters: [String: Any] = [:]) -> [T]? {
      let fetchRequest = NSFetchRequest<T>(entityName: entity.entity().name!)

      for (key, value) in parameters {
          fetchRequest.predicate = NSPredicate(format: "\(key) == %@", value as! CVarArg)
      }

      do {
        let entities = try managedObjectContext.fetch(fetchRequest)
        return entities
      } catch {
        print("Error fetching entities: \(error)")
        return nil
      }
    }

    // Update
    func update<T: NSManagedObject>(entity: T, with parameters: [String: Any]) -> T? {
      for (key, value) in parameters {
        entity.setValue(value, forKey: key)
      }

      do {
        try managedObjectContext.save()
        return entity
      } catch {
        print("Error updating entity: \(error)")
        return nil
      }
    }

    // Delete
    func delete<T: NSManagedObject>(entity: T.Type, with parameters: [String: Any]) {
        let obj = fetch(entity: entity, with: parameters)?.first
        
        if let obj = obj {
            managedObjectContext.delete(obj)
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Error deleting entity: \(error)")
            }
        }
    }
}
