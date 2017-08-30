//
//  ViewController.swift
//  Calculator
//
//  Created by Richard Poutier on 8/29/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display : UILabel!

    private var userIsTyping = false
    
    private var decimalEntered = false
    
    var blo : String = ""
    
    @IBAction func digitPressed(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        let displayString = display.text!
        
        if displayString.contains(".") && digit == "." {
        
        //  do this
        } else {
        
            if userIsTyping {
                let currentDisplayText = display.text!
                display.text = currentDisplayText + digit
            } else {
                display.text = digit
                userIsTyping = true
            }
        }
    }

    private var brain = CalculatorBrain()
    
    var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text! = String(newValue)
        }
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        
        brain.performOperation(sender.currentTitle!)
        
        if let result = brain.result {
            displayValue = result
        }
        
    }
}
