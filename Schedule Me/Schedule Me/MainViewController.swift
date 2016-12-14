//
//  MainViewController.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/12/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//


// Initial view when user opens the application
import Foundation
import UIKit
import EventKit
import SwiftMoment

class mainViewController: UIViewController, CVCalendarMenuViewDelegate, CVCalendarViewDelegate{
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var permissionView: UIView!
    
    
    let eventStore = EKEventStore()
    
    // Calendars specific variables
    var appCalendars: [EKCalendar]?
    var appEvents: [EKEvent]?
    
    // Like, actually the user's current calendar?
    var currentCalendar: Calendar?
    var selectedDay: DayView!
    
    var today = moment()
    
    ///////////////////////////// View Controller Section /////////////////////////////
    // MARK: ViewController Delegates + Functions
    override func viewDidLoad(){
        super.viewDidLoad()
        print("DidLoadCalled")
        checkCalendarAuthorization()
        loadEvents()
        setCurrentCalendar()
        if let currentCalendar = currentCalendar {
            monthTitleLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        print("DidLoadFinished")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        print("DidAppearCalled")
        checkCalendarAuthorization()
        print("DidAppearFinished")
    }
    
    override func viewDidLayoutSubviews() {
        print("DidLayoutCalledBefore")
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        print("DidLayoutCalledFinished")
    }
    
    ///////////////////////////// Calendar Helper Func /////////////////////////////
    // MARK: Calendar Helper Functions
    func setCurrentCalendar(){
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.timeZone = TimeZone.current
    }
    
    func loadCalendars() {
        // This will load all the calendars.. I can also do calendars.(withIdentifier: String)
        self.appCalendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
    }
    
    func loadEvents(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startString = today.format("yyyy-MM-dd")
        let endMoment = today.endOf("M")
        let endString  = endMoment.format("yyyy-MM-dd")
        
        // Get all events within an interval
        let startDate = dateFormatter.date(from: startString)
        let endDate = dateFormatter.date(from: endString)
        
        if let startDate = startDate, let endDate = endDate {
            let eventsPredicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: appCalendars)
            
            self.appEvents = eventStore.events(matching: eventsPredicate).sorted {
                (e1: EKEvent, e2: EKEvent) in
                return e1.startDate.compare(e2.startDate)
                    == ComparisonResult.orderedAscending
            }
        }
    }
    
    
    ///////////////////////////// Calendar Request /////////////////////////////
    // MARK: Calendar Request
    // This should be done in viewWillAppear() because user can grant access at first, but later deny them from settings
    func checkCalendarAuthorization()  {
        // Checking for authorization status here
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestCalendarAuthorization()
        case EKAuthorizationStatus.authorized:
            loadCalendars()
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
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.permissionView.fadeIn()
                })
            }
        })
    }
    
    // Go to settings to change permission when needed
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.openURL(openSettingsUrl!)
    }
    
    ///////////////////////////// Segue Section /////////////////////////////
    // MARK: Segue Prep
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "AddActivitySegue":
                let destVC = segue.destination as! UINavigationController
                let addActivityVC = destVC.childViewControllers[0] as! AddActivityViewController
                addActivityVC.appCalendar = appCalendar
                addActivityVC.delegate = self
            case "SettingsViewSegue":
                // To do here
                print("To do SettingsViewSegue")
            default:
                break
            }
        }
    }*/
    
    ///////////////////////////// CVCalendar Section /////////////////////////////
    // MARK: CVCalendarViewDelegate + CVCalendarMenuViewDelegate
    func presentationMode() -> CalendarMode{
        return .monthView
    }
    
    func firstWeekday() -> Weekday{
        return .sunday
    }
    // Optional delegate
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        let dateFormatter = DateFormatter()
        var dateOriginal: Int?
        dateFormatter.dateFormat = "MM"
        if isViewLoaded{
            let count = appEvents!.count - 1
            if count > 0{
                for i in 0...count{
                    dateOriginal = Int(dateFormatter.string(from: self.appEvents![i].startDate))
                    if Int(dayView.dayLabel.text!) == dateOriginal{
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.red]
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        selectedDay = dayView
        
        /////////////////////////////// Testing variables value ////////////////////////
        print(selectedDay.date.commonDescription)
        print(today.description)
        
        let startString = today.format("yyyy-MM-dd")
        let endMoment = today.endOf("M")
        let endString  = endMoment.format("yyyy-MM-dd")
        
        print(today.description)
        print(startString)
        print(endString)
        
        // print(appCalendars![1].title)
        // print(appCalendars![2].title)
        /////////////////////////// END Testing variables value ////////////////////////
    }
}
