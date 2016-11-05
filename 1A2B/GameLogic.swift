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