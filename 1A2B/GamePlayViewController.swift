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
    @IBOutlet weak var gameDescription: UILabel!
    
    
    @IBAction func inputTextFieldPressed(sender: AnyObject) {
    }
    
    private var inputNumbers = String()
    private var guessingResult = String()
    private var descriptions = String()
    private var checkBool = Bool()
    private var answer = String()
// 去寫robot的class，用object的觀念

    override func viewDidLoad() {
        super.viewDidLoad()

        self.inputTextField.keyboardType = UIKeyboardType.NumberPad
        
        inputTextField.delegate = self
        
        descriptions = "Are you ready? \n Enter your first guess below."
        gameDescription.text = descriptions
        
        guessingResult = "Here're your guessing results:"
        outputLabel.text = guessingResult
        outputLabel.textColor = UIColor.lightGrayColor()
        
        answer = answerGenerator()
        
        // 點擊其他地方視為結束輸入，回傳key in的資料、隱藏keyboard
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GamePlayViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    func didTapView(){
        self.view.endEditing(true)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        inputTextField.becomeFirstResponder()
    }
    

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        return newLength <= 4
    }
    
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let theResult = matchAnswer(input: textField.text!, answer: answer)
        print(textField.text)
        
        guessingResult += "\n \(textField.text!) \(theResult)"
        outputLabel.text = guessingResult
        
        textField.text = nil
        
        inputTextField.becomeFirstResponder()
    }
    
    
    

    
}
