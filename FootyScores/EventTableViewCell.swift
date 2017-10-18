//
//  EventTableViewCell.swift
//  FootyScores
//
//  Created by Ramon Schriks on 16-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var fullTimeProgress: UIProgressView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var event: Event? {
        didSet { self.loadData() }
    }
    
    private func loadData() {
        if event != nil {
            self.homeScore.text = event?.match_hometeam_score
            self.awayScore.text = event?.match_awayteam_score
            self.timeElapsed.text = event?.match_time
            self.homeTeam.text = event?.match_hometeam_name
            self.awayTeam.text = event?.match_awayteam_name
            
            let fullTime = 90
            //self.fullTimeProgress.progress = (fullTime / 100) *
        }
    }
}
