//
//  EventsTableViewDataSource.swift
//  FootyScores
//
//  Created by Ramon Schriks on 21-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import CoreData

class EventsTableViewDataSource: UIViewController, UITableViewDelegate, UITableViewDataSource {
    internal var events: [(key: String, value: [Event])]?
    let eventService = EventService();
    let managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
                eventCell.subscribeClicked = { (button:UIButton) -> Void in
                    self.addFavorite(event, button)
                }
            }
        }
        
        return cell
    }
    
    private func addFavorite(_ event: Event, _ button: UIButton) {
        managedObjectContext?.perform {
            _ = Favorite.addFavorite(with: event.match_id, inManagedObjectContext: self.managedObjectContext!)
            try? self.managedObjectContext?.save()
        }
    }
}
