//
//  ViewController.swift
//  Simple Calculator
//
//  Created by Thadea Achmad on 9/3/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var multiplicandLabel: UILabel!
    
    @IBOutlet weak var multiplierLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chkAnswerButton(sender: UIButton) {
        
        let x : Int = Int(arc4random_uniform(14) + 1)
        let y : Int = Int(arc4random_uniform(14) + 1)

        let z : Int = x * y
        
        multiplicandLabel.text = String(x)
        multiplierLabel.text = String(y)
        
        answerLabel.text = String(z)
        
    }
    
}

