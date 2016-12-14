//
//  EventsViewController.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 11/29/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import EventKit



class EventsViewController: UIViewController, UITableViewDataSource, EventAddedDelegate {
    
    // MARK: Event Added Delegate
    func eventDidAdd() {
        self.loadEvents()
        self.eventsTableView.reloadData()
    }
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var calendar: EKCalendar!
    var events: [EKEvent]?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadEvents()
    }
    
    // I probably want to load events by weekly.. then use SwiftMoments create time intervals object (associated with activities)
    func loadEvents(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Get all events within an interval
        let startDate = dateFormatter.date(from: "2016-01-01")
        let endDate = dateFormatter.date(from: "2016-12-31")
        
        if let startDate = startDate, let endDate = endDate {
            let eventStore = EKEventStore()
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar])
            
            self.events = eventStore.events(matching: eventsPredicate).sorted {
                (e1: EKEvent, e2: EKEvent) in
                return e1.startDate.compare(e2.startDate)
                    == ComparisonResult.orderedAscending
            }
        }
    }
    
    // TableView Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell")!
        cell.textLabel?.text = events?[(indexPath as NSIndexPath).row].title
        cell.detailTextLabel?.text = formatDate(events?[(indexPath as NSIndexPath).row].startDate)
        return cell
    }
    
    // We're gonna assume EST
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE MMM,dd yyyy 'Start:' HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UINavigationController
        
        let addEventVC = destinationVC.childViewControllers[0] as! AddEventViewController
        addEventVC.calendar = calendar
        addEventVC.delegate = self
    }
}
