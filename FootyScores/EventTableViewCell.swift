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
    
    typealias subscribeClickedBlock = (_ button:UIButton) -> Void
    var subscribeClicked: subscribeClickedBlock!
    @IBAction func subscribe(_ sender: UIButton) {
        if subscribeClicked != nil {
            subscribeClicked(sender)
        }
    }
    
    var event: Event? {
        didSet { self.loadData() }
    }
    
    private func loadData() {
        if event != nil {
    
            self.homeScore.text = event?.match_hometeam_score
            self.awayScore.text = event?.match_awayteam_score
            self.homeTeam.text = event?.match_hometeam_name
            self.awayTeam.text = event?.match_awayteam_name
            self.fullTimeProgress.progress = 1
            self.timeElapsed.text = event?.match_status != "" ? event?.match_status : event?.match_time

            if let status = event?.match_status {
                switch status {
                case "FT":
                    self.fullTimeProgress.isHidden = true
                    self.timeElapsed.text = status
                case "HT":
                    self.fullTimeProgress.isHidden = false
                    self.timeElapsed.text = status
                default:
                    let disabled = (event?.match_hometeam_score == "?" || event?.match_awayteam_score == "?")
                    if disabled {
                        self.fullTimeProgress.isHidden = disabled
                        break
                    }
                    
                    if let isLive = event?.match_live {
                        self.fullTimeProgress.isHidden = isLive == "1" ? false : true
                    } else {
                        self.fullTimeProgress.isHidden = true
                    }
                }
            }
        }
    }
}
