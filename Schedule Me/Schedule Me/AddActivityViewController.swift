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
    
    var appCalendar: EKCalendar!
    var delegate: ActivityAdded?
    
    @IBOutlet weak var activityNameTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var isFlexibleButton: UIButton!
    @IBOutlet weak var isConsistentButton: UIButton!
    @IBOutlet weak var SubmitActivity: UIButton!


    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.categoryPickerView.delegate = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryType[row]
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitActivity(_ sender: UIButton) {
        
    }
    
}
