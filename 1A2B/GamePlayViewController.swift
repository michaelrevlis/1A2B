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
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.addTarget(self, action: #selector(GamePlayViewController.didTapView))
//        self.view.addGestureRecognizer(tapRecognizer)
    }
    
//    func didTapView(){
//        self.view.endEditing(true)
//    }
    
    
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
        outputLabel.text = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        answer = calculate(textField.text!)
        
        textField.text = nil
        
        return true
    }
    
    
    func calculate(input: String) -> String {
        
        let answer = "1234".characters
        
        var bothCorrect = Int()
        var numberCorrect = Int()
        
        if input.characters.elementsEqual(answer) {
            return "4A"
        }
        
//        if input.characters.ele
        
        
        
        return "\(bothCorrect)A\(numberCorrect)B"
        
    }
    
}
