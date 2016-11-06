//
//  GameLogic.swift
//  1A2B
//
//  Created by MichaelRevlis on 2016/11/5.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import Foundation

func matchAnswer(input input: String, answer: String) -> String {
    
    let theAnswer = answer.characters
    var temp = theAnswer
    
    var bothCorrect = Int()
    var numberCorrect = Int()
    
    input.characters.forEach() { latter in
        
        if latter == temp.first {
            
            bothCorrect += 1
            
        } else if theAnswer.contains(latter) {
            
            numberCorrect += 1
            
        }
        
        temp = temp.dropFirst()
    }
    
    
    return "\(bothCorrect)A\(numberCorrect)B"
    
}



func answerGenerator() -> String {
    
    let numbers = [1,2,3,4,5,6,7,8,9,0]
    
    return numbers.randomSelect()
    
}



typealias AnswerTypeCorrect = () -> Void
typealias AnswerTypeIncorrect = (error: AnswerTypeError) -> Void

enum AnswerTypeError: ErrorType {
    case LessThan4, DuplicateNumber
}

func checkAnswerType(currentText: String, correct: AnswerTypeCorrect?, incorrect: AnswerTypeIncorrect?) -> Void {
    
    guard currentText.characters.count == 4
        else {
            incorrect?(error: .LessThan4)
            return
    }
    
    var tempText = currentText.characters
    
    for _ in 1...3 {
        
        let character = tempText.first
        
        tempText = tempText.dropFirst()
        
        if tempText.contains(character!) {
            
            incorrect?(error: .DuplicateNumber)
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
            
            matrix.removeAtIndex(index)
            
        }
        
        return pickedNumbers
        
    }
    
}
