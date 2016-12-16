//
//  AddActivityViewController.swift
//  Schedule Me
//
//  Created by Thadea Achmad on 12/14/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class AddActivityViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource{
    
    let model = CoreDataModel.sharedInstance
    
    var appCalendar: EKCalendar!
    var delegate: ActivityAdded?
    var activityToAdd: ActivityMO?
    
    @IBOutlet weak var activityNameTextField: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var isFlexibleButton: UIButton!
    @IBOutlet weak var isConsistentButton: UIButton!
    @IBOutlet weak var SubmitActivity: UIButton!
    
    var cancelBlock : (() -> Void)?
    var saveBlock : (() -> Void)?
    
    var activityName: String?
    var activityCategory: String?
    var isConsistent: Bool = false
    var isFlexible: Bool = false
    var isAdded: Bool = false
    var activityValue: Int16?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    // MARK: - Picker DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryType[row]
    }
    
    
    // MARK: Picker Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activityCategory = categoryType[row]
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func consistentButtonPressed(_ sender: UIButton) {
        if sender.isHighlighted{
            isConsistent = false
            sender.isHighlighted = false
        } else {
            sender.isHighlighted = true
            isConsistent = true
        }
    }
    @IBAction func flexibleButtonPressed(_ sender: UIButton) {
        if sender.isHighlighted{
            isFlexible = false
            sender.isHighlighted = false
        } else {
            sender.isHighlighted = true
            isFlexible = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitActivity(_ sender: UIButton) {
        if let saveBlock = saveBlock{
            activityName = activityNameTextField.text!
            activityValue = Int16(priorityTextField.text!)
        }
    }
    
}
