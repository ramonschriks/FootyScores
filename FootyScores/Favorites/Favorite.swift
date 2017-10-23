//
//  Favorite.swift
//  FootyScores
//
//  Created by Ramon Schriks on 23-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import CoreData

extension Favorite {
    static func getFavorites(inManagedObjectContext context: NSManagedObjectContext) -> [Favorite]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")

        if let favorites = (try? context.fetch(request)) as? [Favorite] {
            return favorites
        }
        return nil
    }
    
    static func addFavorite(with event: Event, inManagedObjectContext context: NSManagedObjectContext) -> Bool {
        if let _ = getFavorite(with: event, inManagedObjectContext: context) {
            _ = updateFavorite(with: event, InManagedObjectContext: context)
            return false
        } else if let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context) as? Favorite {
            favorite.match_id = event.match_id
            favorite.goals = Int16(event.goalscorers.count)
            favorite.cards = Int16(event.goalscorers.count)
            return true
        }
        return false
    }
    
    static func deleteFavorite(with event: Event, inManagedObjectContext context: NSManagedObjectContext) -> Bool {
        if let favorite = getFavorite(with: event, inManagedObjectContext: context) {
            context.delete(favorite)
            return true
        }
        return false
    }
    
    static func getFavorite(with event: Event, inManagedObjectContext context: NSManagedObjectContext) -> Favorite? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "match_id = %@", event.match_id)
        
        if let favorite = (try? context.fetch(request))?.first as? Favorite {
            return favorite
        }
        return nil
    }
    
    static func updateFavorite(with event: Event, InManagedObjectContext context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "match_id = %@", event.match_id)
        
        if let favorite = (try? context.fetch(request))?.first as? Favorite {
            if favorite.cards != event.cards.count ||
                favorite.goals != event.goalscorers.count {
                
                favorite.goals = Int16(event.goalscorers.count)
                favorite.cards = Int16(event.goalscorers.count)
                return true
            }
        }
        return false
    }
}

