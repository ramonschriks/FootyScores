//
//  FirstViewController.swift
//  FootyScores
//
//  Created by Ramon Schriks on 16-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class TodayEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventsTable: UITableView!
    private let eventService = EventService();
    private var events: [(key: String, value: [Event])]? {
        didSet { self.eventsTable.reloadData() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventsTable.estimatedRowHeight = eventsTable.rowHeight
        eventsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEvents()
        self.eventsTable.dataSource = self
    }
    
    private func loadEvents() {
        self.eventService.getTodaysEvents() { [weak weakSelf = self] events in
            weakSelf?.events = events
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = self.events?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let eventDictionary = self.events?[section] {
            return "\(eventDictionary.value[0].country_name!) :: \(eventDictionary.value[0].league_name!)"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventDictionary = self.events?[section] {
            return eventDictionary.value.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        if let league = self.events?[indexPath.section] {
            let event = league.value[indexPath.row]
            if let eventCell = cell as? EventTableViewCell {
                eventCell.event = event
            }
        }
        return cell
    }

}

