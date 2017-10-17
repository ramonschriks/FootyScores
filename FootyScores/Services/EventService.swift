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
    
    public func getTodaysEvents() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let today = formatter.string(from: date)
        
        self.client.getEvents(fromDate: today, toDate: today) { events in
            // TODO: Handle events
        }
    }
}
