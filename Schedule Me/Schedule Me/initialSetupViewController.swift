//
//  initialSetupViewController.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/6/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

//  Usage: Set up initial activity data (class schedule + sleep time) and add to calendar for this week
import Foundation
import UIKit
import DateTimePicker
import SwiftMoment
import DropDown

class initialSetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // // // // // // // Local Data // // // // // // //
    @IBOutlet weak var monthYearPickerView: UIPickerView!
    @IBOutlet weak var multipleUseButton: UIButton!
    
    var currentYear = moment().year
    
    let months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var years = [String]()
    var pickerData: [[String]] = [[String]]()
    var selectedMonth = "01"
    var selectedYear = String(moment().year)
    var dateMonthYear = Date()
    var current = Date()
    
    //var maxDateMonthYear = Date()
    //var minDateMonthYear = Date()
    //var selectedDate = moment()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthYearPickerView.delegate = self
        self.monthYearPickerView.dataSource = self
        years = initializeYearSelections()
        pickerData = [months, years]
        multipleUseButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // // // // // // // Picker Delegate // // // // // // //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    // // // // // // // Picker Source // // // // // // //
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        switch component {
        case 0:
            selectedMonth = String(row.advanced(by: 1))
        case 1:
            selectedYear = years[row]
        default:
            break
        }
        //let string = selectedMonth + selectedYear + "01"
        let string2 = selectedYear + "-" + selectedMonth + "-02"
        dateMonthYear = getDate(dateInString: string2)
        multipleUseButton.isHidden = false
        //minDateMonthYear = getDate(dateInString: string)
        //maxDateMonthYear = Calendar.current.date(byAdding: .day, value: 28, to: dateMonthYear)!
    }
    @IBAction func displayDateTimePicker(_ sender: AnyObject) {
        let min = dateMonthYear.addingTimeInterval(-60 * 60 * 24 * 4)
        let max = dateMonthYear.addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: dateMonthYear, minimumDate: min, maximumDate: max)
        //let margins = view.layoutMarginsGuide
        // margins.bottomAnchor.constraint(equalTo: monthYearPickerView.bottomAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: monthYearPickerView.bottomAnchor).isActive = true
        // picker.addConstraint(monthYearPickerView.bottomAnchor)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.completionHandler = { date in
            self.current = date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd/MM/YYYY"
            //self.item.title = formatter.string(from: date)
        }
    }
    
    // // // // // // // Function Helper // // // // // // //
    //I'll probably create an extension of the moment framework to ease this..
    func getDate(dateInString: String) -> Date {
        let formatToDateObject = DateFormatter()
            formatToDateObject.dateFormat = "yyyy-MM-dd"
        
        let string = dateInString
        let date = formatToDateObject.date(from: string)
        
        return date!
    }
    // Determine the years available to pick in our drop down selection
    func initializeYearSelections() -> [String] {
        var array = [String]()
        for i in 0...4{
            array.append(String(currentYear + i))
        }
        return array
    }
}

/*
 
 // // // // // // // Local Data // // // // // // //
 @IBOutlet weak var getMonthView: UIView!
 @IBOutlet weak var getYearView: UIView!
 
 let dropDownMonth = DropDown()
 let dropDownYear = DropDown()
 let picker = DateTimePicker.show()
 
 var currentYear = moment().year
 let months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
 
 override func viewDidLoad() {
 super.viewDidLoad()
 displayInputSelections()
 //self.view.addSubview(picker)
 }
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 }
 
 func displayInputSelections(){
 dropDownMonth.dataSource = months
 dropDownYear.dataSource = initializeYearSelections()
 dropDownMonth.anchorView = getMonthView
 dropDownYear.anchorView = getYearView
 
 dropDownMonth.show()
 dropDownYear.show()
 }
 

 */
