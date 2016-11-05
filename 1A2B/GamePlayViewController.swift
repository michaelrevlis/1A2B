//
//  GamePlayViewController.swift
//  1A2B
//
//  Created by MichaelRevlis on 2016/11/5.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBAction func inputTextFieldPressed(sender: AnyObject) {
    }
    
    private var inputNumbers = String()
    private var answer = String()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.inputTextField.keyboardType = UIKeyboardType.NumberPad

        inputTextField.delegate = self
        
        answer = "(Answer)"
        
        outputLabel.text = answer
        outputLabel.textAlignment = .Center
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GamePlayViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 4
    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        
//        return true
//    }
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        
//    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        answer = calculate(textField.text!)
        
        outputLabel.text = answer
        
        textField.text = nil
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        
//        return true
//    }
    
    
    func calculate(input: String) -> String {
        
        let answer = "1234".characters
        var temp = answer
        
        var bothCorrect = Int()
        var numberCorrect = Int()
        
        input.characters.forEach() { latter in

            if latter == temp.first {
                
                bothCorrect += 1

            } else if answer.contains(latter) {
                
                numberCorrect += 1
                
            }
            
            temp = temp.dropFirst()
        }
        
        
        return "\(bothCorrect)A\(numberCorrect)B"
        
    }
    
}
