//
//  FavoriteService.swift
//  FootyScores
//
//  Created by Ramon Schriks on 23-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import CoreData

class FavoriteService {
    let notificationService =  NotificationService()
    let managedObjectContext: NSManagedObjectContext!
    private let eventService =  EventService()
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(FavoriteService.notifyChanges), userInfo: nil, repeats: true)
    }
    
    @objc func notifyChanges() {
        loadFavorites() { [weak weakSelf = self] events in
        if let context = weakSelf?.managedObjectContext {
            for event in events {
                if let oldFavorite = Favorite.getFavorite(with: event, inManagedObjectContext: context) {
                    if !Favorite.updateFavorite(with: event, InManagedObjectContext: context) {
                        continue // IN DEMO, COMMENT THIS OUT!
                    }

                    var newGoals: [Activity] = []
                    if let goals = weakSelf?.getSortedActivities(activities: event.goalscorers) as? [Goal] {
                        let missingGoals = goals.count - Int(oldFavorite.goals)
                        if goals.count > 0 {
                            newGoals = Array(goals.suffix(from: missingGoals))
                        }
                    }
           
                    var newCards: [Activity] = []
                    if let cards = weakSelf?.getSortedActivities(activities: event.cards) as? [Card] {
                        let missingCards = cards.count - Int(oldFavorite.cards)
                        if cards.count > 0 {
                            newCards = Array(cards.suffix(from: (missingCards - 1)))
                        }
                    }

                    //newGoals = event.goalscorers // IN DEMO, MANUAL FORCE-SET NEW GOALS
                    if let newActivities = weakSelf?.getSortedActivities(activities: newGoals + newCards) {
                        weakSelf?.sendNotifications(withEvent: event, withActivities: newActivities)
                    }
                }
            }
        }}
    }
    
    private func sendNotifications(withEvent event: Event, withActivities activities: [Activity]) {
        let title = "\(event.match_hometeam_name!) \(event.match_hometeam_score!) - \(event.match_awayteam_name!) \(event.match_awayteam_score!)"
        for activity in activities {
            if let card = activity as? Card {
                let cardType = card.card == "redcard" ? "📕" : "📒"
                var body = "[\(card.time ?? "")] \(cardType)"
                if card.home_fault == "" {
                    body += " - \(card.away_fault ?? "?") (\(event.match_awayteam_name!))"
                } else {
                    body += " - \(card.home_fault ?? "?") (\(event.match_hometeam_name!))"
                }
                
                notificationService.sendNotification(withIdentifier: "card\(card.time ?? "")", withTitle: title, withBody: body)
            }
            
            if let goal = activity as? Goal {
                var body = "[\(goal.time ?? "")] ⚽️ \(goal.score!) ⚽️"
                if goal.home_scorer == "" {
                    body += " - \(goal.away_scorer ?? "?") (\(event.match_awayteam_name!))"
                } else {
                    body += " - \(goal.home_scorer ?? "?") (\(event.match_hometeam_name!))"
                }
                
                notificationService.sendNotification(withIdentifier: "card\(goal.time ?? "")", withTitle: title, withBody: body)
            }
        }
    }
    
    private func loadFavorites(completionBlock: @escaping ([Event]) -> Void) {
        managedObjectContext?.perform {
            if let favorites = Favorite.getFavorites(inManagedObjectContext: self.managedObjectContext!) {
                var favoriteIds: [String] = []
                for favorite in favorites {
                    favoriteIds.append(favorite.match_id!)
                }
                
                DispatchQueue.global(qos: .background).async {
                    self.eventService.getEvents(byIds: favoriteIds) { events in
                        var mergedEvents: [Event] = []
                        for (_, leagueEvents) in events {
                            mergedEvents += leagueEvents
                        }
                        completionBlock(mergedEvents)
                    }
                }
            }
        }
    }
    
    func getSortedActivities(fromEvent event: Event) -> [Activity] {
        var activities: [Activity] = []
        if let goals = event.goalscorers,
            let cards = event.cards {
            activities = activities + goals
            activities = activities + cards
        }
        
        return getSortedActivities(activities: activities)
    }
    
    private func getSortedActivities(activities: [Activity]) -> [Activity] {
        let sortedActivities = activities.sorted { (first: Activity, second: Activity) -> Bool in
            if let firstTime = Int(first.time!.dropLast()),
                let secondTime = Int(second.time!.dropLast()) {
                return firstTime < secondTime
            }
            return true
        }
        return sortedActivities
    }
}
