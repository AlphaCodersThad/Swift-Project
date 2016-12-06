//
//  ActivityTableViewController.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 11/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

// EKEntityType --> 2 cases, .Event or .Reminder

//import Dispatch
import UIKit
import EventKit
import SwiftMoment

class ActivityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarAddedDelegate {
    
    @IBOutlet weak var permissionView: UIView!
    @IBOutlet weak var calendarsTableView: UITableView!
    
    let now = moment()
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        checkCalendarAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        checkCalendarAuthorization()
        // did can also be called as calendarDidAdd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }

    }
    
    func refreshTableView(){
        calendarsTableView.isHidden = false
        calendarsTableView.reloadData()
    }
    
    // MARK: Calendar Added Delegate
    func calendarDidAdd() {
        self.loadCalendars()
        self.refreshTableView()
    }
    
    
    // This should be done in viewWillAppear() because user can grant access at first,
    //   but later deny them from settings
    func checkCalendarAuthorization()  {
        // Checking for authorization status here
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestCalendarAuthorization()
        case EKAuthorizationStatus.authorized:
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            permissionView.fadeIn()
        }
    }
    
    // Ask user for permission to access calendar
    func requestCalendarAuthorization(){
        EKEventStore().requestAccess(to: .event, completion: {(accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.permissionView.fadeIn()
                })
            }
        })
    }
    

    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.openURL(openSettingsUrl!)
    }
    
    // Tableview Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "Unknown Calendar Name"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Finna delete a calendar entry
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Fix my calendar data once you delete them here
        if editingStyle == UITableViewCellEditingStyle.delete {
                do{
                    try eventStore.removeCalendar((self.calendars?[(indexPath as NSIndexPath).row])!, commit: true)
                    calendarDidAdd()
                } catch {
                    let alert = UIAlertController(title: "Calendar could not be deleted", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowAddCalendarView":
                let destinationVC = segue.destination as! UINavigationController
                let addCalendarVC = destinationVC.viewControllers[0] as! AddCalendarViewController
                addCalendarVC.delegate = self
            case "ShowEventsView":
//                let destinationVC = segue.destinationViewController as! UINavigationController
                let eventsVC = segue.destination as! EventsViewController
                let selectedIndexPath = calendarsTableView.indexPathForSelectedRow!
                
                eventsVC.calendar = calendars?[(selectedIndexPath as NSIndexPath).row]
            default:
                break
            }
        }
    }
}


extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

