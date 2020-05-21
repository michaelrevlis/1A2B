//
//  GameLogic.swift
//  1A2B
//
//  Created by MichaelRevlis on 2016/11/5.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import Foundation

func matchAnswer(input: String, answer: String) -> String {
    
    let theAnswer = answer
    var temp = theAnswer
    
    var bothCorrect = Int()
    var numberCorrect = Int()
    
    input.forEach() { latter in
        
        if latter == temp.first {
            
            bothCorrect += 1
            
        } else if theAnswer.contains(latter) {
            
            numberCorrect += 1
            
        }
        
        temp = String(temp.dropFirst())
    }
    
    
    return "\(bothCorrect)A\(numberCorrect)B"
    
}



func answerGenerator() -> String {
    
    let numbers = [1,2,3,4,5,6,7,8,9,0]
    
    return numbers.randomSelect()
    
}



typealias AnswerTypeCorrect = () -> Void
typealias AnswerTypeIncorrect = (_ error: AnswerTypeError) -> Void

enum AnswerTypeError: Error {
    case LessThan4, DuplicateNumber
}

func checkAnswerType(currentText: String, correct: AnswerTypeCorrect?, incorrect: AnswerTypeIncorrect?) -> Void {
    
    guard currentText.count == 4
        else {
            incorrect?(.LessThan4)
            return
    }
    
    var tempText = currentText
    
    for _ in 1...3 {
        
        let character = tempText.first
        
        tempText = String(tempText.dropFirst())
        
        if tempText.contains(character!) {
            
            incorrect?(.DuplicateNumber)
            return
        }
    }
    
    correct?()
    
}




extension Array {
    
    func randomSelect() -> String {
        
        var matrix = self
        var pickedNumbers = String()
        
        for _ in 1...4 {
            
            let index = Int(arc4random_uniform(UInt32(matrix.count)))
            
            pickedNumbers += "\(matrix[index])"
            
            matrix.remove(at: index)
            
        }
        
        return pickedNumbers
        
    }
    
}
