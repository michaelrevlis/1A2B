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
    @IBOutlet weak var errorDescription: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    
    
    @IBAction func inputTextFieldPressed(sender: AnyObject) {
    }
    @IBAction func replayButtonPressed(sender: AnyObject) {
        playNewGame()
    }
    
    
    private var inputNumbers = String()
    private var guessingResult = String()
    private var descriptions = String()
    private var checkBool = Bool()
    private var answer = String()
    private let returnButton = UIButton(type: UIButtonType.Custom)
    private var submitTimes: Int = 0
// 去寫robot的class，用object的觀念

    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self
        
        outputLabel.textColor = UIColor.darkGrayColor()
        
        setupReturnButton()
                
        playNewGame()
        
        // 點擊其他地方視為結束輸入，回傳key in的資料、隱藏keyboard
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GamePlayViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    
    func setupReturnButton() {
        returnButton.setTitle("Go", forState: UIControlState.Normal)
        returnButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        returnButton.contentHorizontalAlignment = .Center
        returnButton.frame = CGRectMake(0, 163, self.view.frame.width / 3 , 53)
        returnButton.titleLabel?.adjustsFontSizeToFitWidth = true
        returnButton.addTarget(self, action: #selector(GamePlayViewController.Go(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func Go(sender: UIButton) {
        didTapView()
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
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GamePlayViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let currentText = textField.text!
        
        checkAnswerType(currentText,
            
            correct: {
                
                self.errorDescription.text = ""
                
                let theResult = matchAnswer(input: currentText, answer: self.answer)
                
                self.guessingResult += "\n \(currentText) \(theResult)"
                
                self.outputLabel.text = self.guessingResult
                
                textField.text = nil
                
                self.inputTextField.becomeFirstResponder()
                
                self.submitTimes += 1
                
                switch self.submitTimes {
                case 1:
                    self.gameDescription.text = "GAME START!!"
                    break
                case 5:
                    self.gameDescription.text = "Keep on going! \nYou're almost there"
                    break
                case 8:
                    self.gameDescription.text = "Wanna give up? \nCome on you can do this"
                    break
                case 12:
                    self.gameDescription.text = "You should practice more..."
                    self.replayButton.hidden = false
                    return
                default: break
                }
                
                if theResult == "4A0B" {
                    self.gameDescription.text = "You WIN! \n Congratulation"
                    self.replayButton.hidden = false
                }
                
            },
            
            incorrect: { error in
                
                switch error {
                
                case .LessThan4:
                    self.errorDescription.text = "Less than 4 numbers!"
                    self.inputTextField.text = nil
                    self.inputTextField.becomeFirstResponder()
                    break
                    
                case .DuplicateNumber:
                    self.errorDescription.text = "Duplicate number!"
                    self.inputTextField.text = nil
                    self.inputTextField.becomeFirstResponder()
                    break
                }
            }
                
            
        )
        
    }
    
    
    
    func keyboardWillShow(note : NSNotification) -> Void{
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.returnButton.hidden = false
            let keyBoardWindow = UIApplication.sharedApplication().windows.last
            self.returnButton.frame = CGRectMake(0, (keyBoardWindow?.frame.size.height)!-53, self.view.frame.width / 3 , 53)
            keyBoardWindow?.addSubview(self.returnButton)
            keyBoardWindow?.bringSubviewToFront(self.returnButton)
            UIView.animateWithDuration(((note.userInfo! as NSDictionary).objectForKey(UIKeyboardAnimationCurveUserInfoKey)?.doubleValue)!, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.view.frame = CGRectOffset(self.view.frame, 0, 0)
                }, completion: { (complete) -> Void in
            })
        }
    }
    
    
    
    func playNewGame() {
        
        descriptions = "Are you ready? \n Enter your first guess below."
        gameDescription.text = descriptions
        
        guessingResult = "Here're your guessing results:"
        outputLabel.text = guessingResult

        answer = answerGenerator()
        print("answer: \(answer)")
        
        replayButton.hidden = true

        inputTextField.becomeFirstResponder()

    }

    
}
