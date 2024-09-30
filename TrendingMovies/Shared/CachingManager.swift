//
//  CachingManager.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation
import CoreData

class CachingManager {
    static let shared = CachingManager()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }

    func save<T: Encodable>(data: T, forKey key: String) {
        let context = container.viewContext

        do {
            let encodedData = try JSONEncoder().encode(data)
            let entityDescription = NSEntityDescription.entity(forEntityName: "CachedData", in: context)!
            let newEntity = NSManagedObject(entity: entityDescription, insertInto: context)
            newEntity.setValue(key, forKey: "key")
            newEntity.setValue(encodedData, forKey: "data")
            try context.save()
        } catch {
            print("Error encoding data: \(error)")
        }
    }

    func retrieve<T: Decodable>(forKey key: String) -> T? {
        let context = container.viewContext

        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CachedData")
        request.predicate = NSPredicate(format: "key == %@", key)

        do {
            let results = try context.fetch(request)
            if let result = results.first {
                let encodedData = result.value(forKey: "data") as! Data
                return try JSONDecoder().decode(T.self, from: encodedData)
            }
        } catch {
            print("Error decoding data: \(error)")
        }
        return nil
    }

    func clear() {
        let context = container.viewContext
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CachedData")
        do {
            let results = try context.fetch(request)
            for result in results {
                context.delete(result)
            }
            try context.save()
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
}
