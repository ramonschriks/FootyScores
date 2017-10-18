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
    
    public func getTodaysEvents(completionBlock: @escaping ([(key: String, value: [Event])]) -> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let today = formatter.string(from: date)
        
        self.client.getEvents(fromDate: today, toDate: today) { [weak weakSelf = self] events in
            if let events = weakSelf?.sortEventsOnCountry(events) {
                completionBlock(events)
            }
        }
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
