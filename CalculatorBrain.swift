//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Richard Poutier on 8/29/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator : Double?
    
    var resultIsPending : Bool {
        if pendingBinaryOperation != nil {
            return true
        } else {
            return false
        }
    }
    
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations : Dictionary<String,Operation> =
        ["π" : .constant(Double.pi),
        "e" : .constant(M_E),
        "⅟x" : .unaryOperation({ 1/$0 }),
        "%" : .unaryOperation({ $0 / 100 }),
        "√" : .unaryOperation(sqrt),
        "^2" : .unaryOperation({ $0 * $0}),
        "C" : .constant(0.0),
        "±" : .unaryOperation({ -$0 }),
        "÷" : .binaryOperation({ $0 / $1 }),
        "×" : .binaryOperation({ $0 * $1 }),
        "−" : .binaryOperation({ $0 - $1 }),
        "+" : .binaryOperation({ $0 + $1 }),
        "=" : .equals]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
        
    }
    
    mutating func performPendingBinaryOperation() {
        if accumulator != nil && pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation?.performOperation(with: accumulator!)
        }
        
    }
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    struct PendingBinaryOperation {
        var function : (Double, Double) -> Double
        var firstOperand : Double
        
       mutating func performOperation(with secondOperand : Double) ->Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ value: Double) {
        accumulator = value
    }
    
    var result : Double? {
        return accumulator
    }
    
    func description() -> String {
        
        if !resultIsPending {
            return "\(accumulator)"
        }
        
        return ""
    }
    
}
