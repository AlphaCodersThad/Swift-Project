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
    var selectedMonth = String()
    var selectedYear = String()
    //var selectedDate = moment()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthYearPickerView.delegate = self
        self.monthYearPickerView.dataSource = self
        years = initializeYearSelections()
        pickerData = [months, years]
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        switch component {
        case 1:
            selectedMonth = months[row]
        case 2:
            selectedYear = years[row]
        default:
            break
        }
        
        selectedDate =
    }
    @IBAction func displayDateTimePicker(_ sender: UIButton) {
        let picker = DateTimePicker.show(selected: )
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
