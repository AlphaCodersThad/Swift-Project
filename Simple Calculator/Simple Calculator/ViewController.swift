//
//  ViewController.swift
//  Simple Calculator
//
//  Created by Thadea Achmad on 9/3/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: stuff..
    //Multipliers, Multiplicand, Answer, and Index
    var num1: Int = 0
    var num2: Int = 0
    var num3: Int = 0
    var selectedIndex: Int = 0
    var correctCounter: Int = 0
    var progressCounter: Float = 0
    var progressDisplay: Int = 0

    var newTintColor: UIColor?

    /*required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    
    @IBOutlet weak var multiplicandLabel: UILabel!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    
    @IBOutlet weak var answerSeperatorBar: UIView!

    @IBOutlet weak var selectAnswer: UISegmentedControl!
    @IBOutlet weak var multipleUseButton: UIButton!
    @IBOutlet weak var correctIncorrectLabel: UILabel!
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var numCorrect: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initStartScreen()
    }
    
    // MARK: Action
    
    @IBAction func chkAnswerButton(sender: UIButton) {
        
        
        // May be better to use a switch statement instead
        let switchControl: String = (multipleUseButton.titleLabel?.text)!
        switch switchControl
        {
        case "Submit":
            selectedIndex = selectAnswer.selectedSegmentIndex
            num3 = num1 * num2
            if(Int(selectAnswer.titleForSegmentAtIndex(selectedIndex)!) == num3)
            {
                correctIncorrectLabel.hidden = false
                correctIncorrectLabel.text = "Correct!"
                correctCounter += 1
            }
            else{
                correctIncorrectLabel.hidden = false
                correctIncorrectLabel.text = "You suck!"
            }
            
            progressCounter += 0.1
            progressDisplay += 1
            
            // Im hiding the number of correct until user answer the very first question
            if(progressDisplay == 1){
                numCorrect.hidden = false
            }
            progressIndicator.setProgress(progressCounter, animated: true)
            numCorrect.text = "\(correctCounter)/\(progressDisplay) Correct!"
            
            if (progressDisplay >= 10){
                multipleUseButton.setTitle("Reset", forState: UIControlState.Normal)
            }
            else{
                multipleUseButton.setTitle("Next!", forState: UIControlState.Normal)
            }
            
            
            answerLabel.hidden = false
            
            
        case "Next!":
            initMathProblems()
            multipleUseButton.setTitle("Submit", forState: UIControlState.Normal)
            // Not too familiar with button state, so I'm just gonna hide to prevent error for now
            multipleUseButton.hidden = true
            selectAnswer.selectedSegmentIndex = -1
            
        case "Reset":
            initStartScreen()
            
        default:
            initStartGame()
            initMathProblems()
            multipleUseButton.setTitle("Submit", forState: UIControlState.Normal)
            
        }
        
    }
    
    @IBAction func switchAnswer(sender: UISegmentedControl) {
        
        // Now you can submit the answers

        multipleUseButton.hidden = false
        newTintColor = UIColor(red: CGFloat((arc4random() % 256))/255.0, green:( CGFloat((arc4random() % 256)))/255.0, blue: CGFloat(((arc4random() % 256)))/255.0, alpha: 1)
        
        
        // This was unnecessary but I'm keeping it here for reminder purpose
        switch selectAnswer.selectedSegmentIndex
        {
        case 0:
            selectAnswer.tintColor = newTintColor
            
        case 1:
            selectAnswer.tintColor = newTintColor
        case 2:
            selectAnswer.tintColor = newTintColor

        default:
            selectAnswer.tintColor = newTintColor
        }
    }
    
    // Initialize the problems
    func initMathProblems(){
        
        num1 = Int(arc4random_uniform(14) + 1)
        num2 = Int(arc4random_uniform(14) + 1)
        num3 = num1 * num2
        
        // Can I define an array here maybe
        let num4: Int = num3 + Int(arc4random_uniform(5))
        let num5: Int = num4 + 1
        let num6: Int = num4 - 1
        
        /*do{
            num5 = num3 + Int(arc4random_uniform(5)+1)
        };(num5 == num4)*/
        
        var arrayOriginal = [Int](arrayLiteral: num3, num4, num5, num6)
        arrayOriginal.shuffleInPlace()
        
        multiplicandLabel.text = String(num1)
        multiplierLabel.text = String(num2)
        answerLabel.text = String(num3)
        
        // Need to redo better (randomize segmented control choice)
        selectAnswer.setTitle(String(arrayOriginal[0]), forSegmentAtIndex: 0)
        selectAnswer.setTitle(String(arrayOriginal[1]), forSegmentAtIndex: 1)
        selectAnswer.setTitle(String(arrayOriginal[2]), forSegmentAtIndex: 2)
        selectAnswer.setTitle(String(arrayOriginal[3
            ]), forSegmentAtIndex: 3)
        
        // Make sense to put here
        correctIncorrectLabel.hidden = true
        answerLabel.hidden = true
        
    }
    // Hide everything but the Start button
    func initStartScreen(){
        multiplicandLabel.hidden = true
        multiplierLabel.hidden = true
        answerSeperatorBar.hidden = true
        answerLabel.hidden = true
        selectAnswer.hidden = true
        correctIncorrectLabel.hidden = true
        progressIndicator.hidden = true
        numCorrect.hidden = true
        multipleUseButton.setTitle("Start Game", forState: UIControlState.Normal)
        
        progressIndicator.setProgress(0, animated: true)
        progressCounter = 0
        
        progressDisplay = 0
        correctCounter = 0
        selectAnswer.selectedSegmentIndex = -1
        

    }
    
    // Now we show everything.. can this two functions be done a lot more efficiently (cleaner)
    func initStartGame(){
        multiplicandLabel.hidden = false
        multiplierLabel.hidden = false
        answerSeperatorBar.hidden = false
        answerLabel.hidden = false
        selectAnswer.hidden = false
        correctIncorrectLabel.hidden = false
        progressIndicator.hidden = false
        multipleUseButton.hidden = true
        // numCorrect.hidden = false
    }
    
    
}

//////////////////////SHUFFLE EXTENSION I FOUND ON GITHUB///////////////////////

// (c) 2015 Nate Cook, licensed under the MIT license
//
// Fisher-Yates shuffle as protocol extensions

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////

