//
//  SecondViewController.swift
//  FootyScores
//
//  Created by Ramon Schriks on 16-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: EventsTableViewDataSource {
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var eventsTable: UITableView!
    
    private let refreshControl = UIRefreshControl()
    override internal var events: [(key: String, value: [Event])]? {
        didSet { self.eventsTable.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadFavorites()
        eventsTable.estimatedRowHeight = eventsTable.rowHeight
        eventsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTable.dataSource = self
        self.configureRefreshControl()
        self.loadFavorites()
    }
    
    private func configureRefreshControl() {
        if #available(iOS 10.0, *) {
            self.eventsTable.refreshControl = refreshControl
        } else {
            self.eventsTable.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(loadFavorites), for: .valueChanged)
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
    
    @objc private func loadFavorites() {
        self.loading(enable: true)
        
        managedObjectContext?.perform {
            if let favorites = Favorite.getFavorites(inManagedObjectContext: self.managedObjectContext!) {
                var favoriteIds: [String] = []
                for favorite in favorites {
                    favoriteIds.append(favorite.match_id!)
                }
                
                DispatchQueue.main.async {
                    self.eventService.getEvents(byIds: favoriteIds) { [weak weakSelf = self] events in
                        weakSelf?.events = events
                        self.loading(enable: false)
                    }
                }
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

