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

    //MARK: Create
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

    //MARK: Fetch
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
    
    func fetchResources(for course: Course) -> [Resource] {
        let fetchRequest = NSFetchRequest<Resource>(entityName: Resource.entity().name!)

        fetchRequest.predicate = NSPredicate(format: "course == %@", course)

        let resources = try! managedObjectContext.fetch(fetchRequest)

        return resources
    }
    
    
    func fetchLinks(for resource: Resource) -> [Link] {
      // Get the links relationship from the resource.
      let linksRelationship = resource.links

      // Get the links from the links relationship.
        let links = linksRelationship?.allObjects as? [Link]

      // Return the links.
      return links ?? []
    }


    //MARK: Update
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

    //MARK: Delete
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
    
    func delete(_ obj: NSManagedObject?) {
        if let obj = obj {
            managedObjectContext.delete(obj)
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Error deleting entity: \(error)")
            }
        }
    }
    
    func deleteAll<T: NSManagedObject>(_ entity: T.Type) {
        let managedObjectContext = CoreDataStack.shared.managedObjectContext

        // Create a fetch request for the specified entity
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>

        do {
            // Fetch all objects of the specified entity
            let objects = try managedObjectContext.fetch(fetchRequest)

            for object in objects {
                // Delete each object
                managedObjectContext.delete(object)
            }

            // Save the changes to the managed object context
            try managedObjectContext.save()
        } catch {
            print("Error deleting all entities: \(error)")
        }
    }

    
}
