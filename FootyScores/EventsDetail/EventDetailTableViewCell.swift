//
//  EventDetailTableViewCell.swift
//  FootyScores
//
//  Created by Ramon Schriks on 23-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var typeHomeLabel: UILabel!
    @IBOutlet weak var playerHomeLabel: UILabel!
    @IBOutlet weak var typeAwayLabel: UILabel!
    @IBOutlet weak var playerAwayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var activity: Activity? { didSet{ loadMatchActivity() }}
    
    private func loadMatchActivity() {
        if let card = self.activity as? Card {
            loadCard(card: card)
        }
        
        if let goal = self.activity as? Goal {
            loadGoal(goal: goal)
        }
    }
    
    private func loadCard(card: Card) {
        var typeLabel = ""
        if card.card == "yellowcard" {
            typeLabel = "📒"
        } else if card.card == "redcard" {
            typeLabel = "📕"
        }
        
        if card.home_fault == "" {
            loadAway(type: typeLabel, player: card.away_fault!)
        } else {
            loadHome(type: typeLabel, player: card.home_fault!)
        }
        
        timeLabel.text = card.time
    }
    
    private func loadGoal(goal: Goal) {
        let typeLabel = "⚽️"
        if goal.home_scorer == "" {
            loadAway(type: typeLabel, player: goal.away_scorer!)
        } else {
            loadHome(type: typeLabel, player: goal.home_scorer!)
        }
        timeLabel.text = goal.time
    }
    
    private func loadHome(type: String, player: String) {
        typeHomeLabel.text = type
        playerHomeLabel.text = player
        typeAwayLabel.isHidden = true
        playerAwayLabel.isHidden = true
    }
    
    private func loadAway(type: String, player: String) {
        typeAwayLabel.text = type
        playerAwayLabel.text = player
        typeHomeLabel.isHidden = true
        playerHomeLabel.isHidden = true
    }
}
