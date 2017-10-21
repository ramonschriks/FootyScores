//
//  ApiFootballClient.swift
//  FootyScores
//
//  Created by Ramon Schriks on 16-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ApiFootballClient {
   private let apiKey = ""
    
    public func getEvents(fromDate from: String, toDate to: String, completionBlock: @escaping ([Event]) -> Void) {
        let url = "https://apifootball.com/api/?action=get_events&from=\(from)&to=\(to)&APIkey=\(self.apiKey)"
        
        self.requestJSON(url) { events in
            completionBlock(events)
        }
    }
    
    public func getEvents(fromId id: String, fromDate from: String, toDate to: String, completionBlock: @escaping ([Event]) -> Void) {
        let url = "https://apifootball.com/api/?action=get_events&from=\(from)&to=\(to)&match_id=\(id)&APIkey=\(self.apiKey)"

        self.requestJSON(url) { events in
            completionBlock(events)
        }
    }
        
    private func requestJSON(_ jsonURL: String, completionBlock: @escaping ([Event]) -> Void) {
        Alamofire.request(jsonURL).responseJSON { response in
 
            var events: [Event] = []
            if let jsonData = response.result.value as? [Any] {
                for json in jsonData{
                    if let jsonArray = json as? [String: Any] {
                        
                        do {
                            let event = Event()
                            event.country_id = jsonArray["country_id"]! as! String
                            event.country_name = jsonArray["country_name"]! as! String
                            event.league_id = jsonArray["league_id"]! as! String
                            event.league_name = jsonArray["league_name"]! as! String
                            event.match_awayteam_halftime_score = jsonArray["match_awayteam_halftime_score"]! as! String
                            event.match_awayteam_name = jsonArray["match_awayteam_name"]! as! String
                            event.match_awayteam_score = jsonArray["match_awayteam_score"]! as! String
                            event.match_date = jsonArray["match_date"]! as! String
                            event.match_hometeam_halftime_score = jsonArray["match_hometeam_halftime_score"]! as! String
                            event.match_hometeam_name = jsonArray["match_hometeam_name"]! as! String
                            event.match_hometeam_score = jsonArray["match_hometeam_score"]! as! String
                            event.match_id = jsonArray["match_id"]! as! String
                            event.match_live = jsonArray["match_live"]! as! String
                            event.match_status = jsonArray["match_status"]! as! String
                            event.match_time = jsonArray["match_time"]! as! String
                            events.append(event)
                        } catch {
                            // Just skip the event
                        }
                    }
                }
            }
            completionBlock(events)
        }
    }
}

