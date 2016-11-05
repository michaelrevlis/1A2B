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
    private var result = String()
    private var checkBool = Bool()
// 去寫robot的class，用object的觀念

    override func viewDidLoad() {
        super.viewDidLoad()

        self.inputTextField.keyboardType = UIKeyboardType.NumberPad
        self.inputTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        
        inputTextField.delegate = self
        
        result = "(Answer)"
        
        outputLabel.text = result
        outputLabel.textAlignment = .Center
        
        
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
        
        result = matchAnswer(input: textField.text!, answer: "1234")
        print(textField.text)
        
        outputLabel.text = result
        
        textField.text = nil
        
        inputTextField.becomeFirstResponder()
    }
    
    
    

    
}
