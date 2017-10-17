//
//  Event.swift
//  FootyScores
//
//  Created by Ramon Schriks on 17-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation

class Event {
    var cards: [Any]!
    var goalscorer: [Any]!

    var country_id: String!
    var country_name: String!
    var league_id: String!
    var league_name: String?
    var match_awayteam_halftime_score: String!
    var match_awayteam_name: String!
    var match_awayteam_score: String!
    var match_date: String!
    var match_hometeam_halftime_score: String!
    var match_hometeam_name: String!
    var match_hometeam_score: String!
    var match_id: String!
    var match_live: String!
    var match_status: String!
    var match_time: String!
}
