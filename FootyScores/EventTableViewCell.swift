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
}
