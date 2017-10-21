//
//  EventService.swift
//  FootyScores
//
//  Created by Ramon Schriks on 17-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation

class EventService {
    private let client = ApiFootballClient();
    
    public func getEvents(byIds ids: [String], completionBlock: @escaping ([(key: String, value: [Event])]) -> Void) {
        let from = DateUtil.getStringDateFrom(days: 3)
        let to = DateUtil.getStringDateTo(days: 3)
  
        let multiRequestGroup = DispatchGroup()
        var favoriteEvents: [Event] = []
        
        for id in ids {
            multiRequestGroup.enter()
            self.client.getEvents(fromId: id, fromDate: from, toDate: to) { events in
                for event in events {
                    favoriteEvents.append(event)
                    multiRequestGroup.leave()
                }
            }
        }
        multiRequestGroup.notify(queue: .main) {
            completionBlock(self.sortEventsOnCountry(favoriteEvents))
        }
    }
    
    public func getEvents(dateOffset offset: Int, completionBlock: @escaping ([(key: String, value: [Event])]) -> Void) {
        let today = DateUtil.getStringDateTo(days: offset)
        
        self.client.getEvents(fromDate: today, toDate: today) { [weak weakSelf = self] events in
            if let events = weakSelf?.sortEventsOnCountry(events) {
                completionBlock(events)
            }
        }
    }
    
    public func filterLiveEvents(_ events: [(key: String, value: [Event])], completionBlock: @escaping ([(key: String, value: [Event])]) -> Void) {
        var liveEvents: [Event] = []
        for (_,leagueEvents) in events {
            for leagueEvent in leagueEvents {
                if (leagueEvent.match_live == "1" && leagueEvent.match_status != ""){
                    let matchStatusTime = leagueEvent.match_status.dropLast() // Drop the ' after the 34' to cast to a legit number
                    if let _ = Int(matchStatusTime){
                       liveEvents.append(leagueEvent)
                    }
                }
            }
        }
        completionBlock(self.sortEventsOnCountry(liveEvents))
    }
    
    /**
     * Sort the events based on the on the country ID (lower to country key, the important the league).
     * Create a new Dictionary from the events that hold the country id as key.
     */
    private func sortEventsOnCountry(_ events: [Event]) -> [(key: String, value: [Event])] {
        var countryEvents: [String: [Event]] = [:]
        for event in events {
            if event.country_id != nil && event.league_id != nil {
                let countryLeagueId = "\(event.country_id!) :: \(event.league_id!)"
                if countryEvents[countryLeagueId] == nil {
                    countryEvents[countryLeagueId] = []
                }
                countryEvents[countryLeagueId]?.append(event)
            }
        }
        
        let sortedEvents = countryEvents.sorted { (first: (key: String, value: [Event]), second: (key: String, value: [Event])) -> Bool in
            return first.key < second.key
        }
        
        return sortedEvents
    }
}
