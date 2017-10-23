//
//  EventsDetailViewController.swift
//  FootyScores
//
//  Created by Ramon Schriks on 22-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class EventsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var eventDetailTable: UITableView!
    
    var event: Event? { didSet { activities = getSortedActivities(event: event!)} }
    private var activities: [Activity]?
    private var originTintColor: UIColor?
    private var originBarTintColor: UIColor?
    
    override func viewWillAppear(_ animated: Bool) {
        self.originBarTintColor = self.navigationController?.navigationBar.barTintColor
        self.originTintColor = self.navigationController?.navigationBar.tintColor

        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 250/255, green: 212/255, blue: 134/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tintColor = self.originTintColor,
            let barTintColor = self.originBarTintColor{
            self.navigationController?.navigationBar.tintColor = tintColor
            self.navigationController?.navigationBar.barTintColor = barTintColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                self.eventDetailTable.dataSource = self
        loadEventInfo()
    }
    
    private func loadEventInfo() {
        homeTeamLabel.text = event?.match_hometeam_name
        homeTeamScoreLabel.text = event?.match_hometeam_score
        awayTeamLabel.text = event?.match_awayteam_name
        awayTeamScoreLabel.text = event?.match_awayteam_score
        matchStatusLabel.text = event?.match_status
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (activities?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        if let eventDetailCell = cell as? EventDetailTableViewCell {
            if let activities = self.activities {
                eventDetailCell.activity = activities[indexPath.row]
            }
        }
   
        return cell
    }
    
    private func getSortedActivities(event: Event) -> [Activity] {
        var activities: [Activity] = []
        if let goals = event.goalscorers,
            let cards = event.cards {
            activities = activities + goals
            activities = activities + cards
        }
        
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
