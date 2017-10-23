//
//  FirstViewController.swift
//  FootyScores
//
//  Created by Ramon Schriks on 16-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class EventsViewController: EventsTableViewDataSource {
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var liveSwitch: UISwitch!
    
    private let refreshControl = UIRefreshControl()
    override internal var events: [(key: String, value: [Event])]? {
        didSet { self.eventsTable.reloadData() }
    }
    private var liveEvents: [(key: String, value: [Event])]?
    private var allEvents: [(key: String, value: [Event])]?
    
    private let maxNextOffset = 3
    private let maxPrevOffset = -3
    private var dateOffset: Int = 0 {
        didSet {
            self.loadEvents()
            let dateString = (dateOffset == 0) ? "Todays" : DateUtil.getStringDateTo(days: dateOffset)
            self.title = "\(dateString) events"
        }} // Start with today (no offset)

    override func viewWillAppear(_ animated: Bool) {
        self.loadEvents()
        eventsTable.estimatedRowHeight = eventsTable.rowHeight
        eventsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveSwitch.addTarget(self, action: #selector(self.switchEvents(_:)), for: UIControlEvents.valueChanged)
        
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
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func nextDay(_ sender: UIButton) {
        if !(dateOffset + 1 > maxNextOffset)  {
            dateOffset = dateOffset + 1
        }
    }
    
    @IBAction func prevDay(_ sender: UIButton) {
        if !(dateOffset - 1 < maxPrevOffset) {
            dateOffset = dateOffset - 1
        }
    }
    
    @objc func switchEvents(_ liveSwitch: UISwitch) {
        self.events = liveSwitch.isOn ? self.liveEvents : self.allEvents
    }
    
    @objc private func loadEvents() {
        self.loading(enable: true)
        self.liveSwitch.setOn(false, animated: true)
        
        DispatchQueue.main.async {
            self.eventService.getEvents(dateOffset: self.dateOffset) { [weak weakSelf = self] events in
                weakSelf?.allEvents = events
                // Also load live events
                self.eventService.filterLiveEvents(events) { liveEvents in
                    weakSelf?.liveEvents = liveEvents
                }
                
                weakSelf?.events = weakSelf?.allEvents
                weakSelf?.loading(enable: false)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination.contents as? EventsDetailViewController {
            if let detailCell = sender as? EventTableViewCell {
                detailVC.event = detailCell.event
            }
        }
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        return self
    }
}

