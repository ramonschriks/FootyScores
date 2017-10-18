//
//  FirstViewController.swift
//  FootyScores
//
//  Created by Ramon Schriks on 16-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class TodayEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var eventsTable: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let eventService = EventService();
    private var events: [(key: String, value: [Event])]? {
        didSet { self.eventsTable.reloadData() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadEvents()
        eventsTable.estimatedRowHeight = eventsTable.rowHeight
        eventsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTable.dataSource = self
        self.configureRefreshControl()
        self.loadEvents()
    }
    
    private func configureRefreshControl() {
        if #available(iOS 10.0, *) {
            self.eventsTable.refreshControl = refreshControl
        } else {
            self.eventsTable.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(loadEvents), for: .valueChanged)
    }
    
    private func loading(enable: Bool) {
        self.eventsTable.isHidden = enable
        self.activity.isHidden = !enable
        self.activityLabel.isHidden = !enable
        
        if enable {
            self.activity.startAnimating()
        } else {
            self.activity.stopAnimating()
        }
    }
    
    @objc private func loadEvents() {
        self.loading(enable: true)
        DispatchQueue.main.async {
            self.eventService.getTodaysEvents() { [weak weakSelf = self] events in
                weakSelf?.events = events
                weakSelf?.loading(enable: false)
                self.refreshControl.endRefreshing()
            }
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

