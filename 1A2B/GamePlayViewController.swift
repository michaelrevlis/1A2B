//
//  GamePlayViewController.swift
//  1A2B
//
//  Created by MichaelRevlis on 2016/11/5.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import CoreData

class GamePlayViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var timeKeepCounting: UILabel!
    @IBOutlet weak var lastSubmitTime: UILabel!
    @IBOutlet weak var historyRecordsAve: UILabel!
    
    
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
    private var timer = NSTimer()
    private var timeCount: Double = 0
    private var historyRecords: [Double] = [] // records from history, used to get last 10 records
    private var last10records: [Double] = []
    var gamePlayTime: [Double] = [] // records start from today's game play
    

    override func viewDidLoad() {
        super.viewDidLoad()

        getLast10Records()

        inputTextField.delegate = self
        
        outputLabel.textColor = UIColor.darkGrayColor()
        
        setupReturnButton()
                
        playNewGame()
        
        timeKeepCounting.hidden = true
        lastSubmitTime.hidden = true
        
        updateAverage(last10records)
        
        // 點擊其他地方視為結束輸入，回傳key in的資料、隱藏keyboard
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GamePlayViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        inputTextField.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        let appDelegate = AppDelegate()
        appDelegate.saveGamePlayTime(gamePlayTime)
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
                    self.startCountingTime()
                    break
                    
                case 5:
                    self.gameDescription.text = "Keep on going! \nYou're almost there"
                    break
                    
                case 8:
                    self.gameDescription.text = "Wanna give up? \nCome on you can do this"
                    break
                    
                case 12:
                    self.gameDescription.text = "You should practice more..."
                    return
                    
                default: break
                }
                
                self.updateSubmitTime()
                
                if theResult == "4A0B" {
                    self.gameDescription.text = "You WIN! \n Congratulation"
                    self.stopTime()
                    self.updateGamePlayTime(self.timeCount)
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
        
        inputTextField.becomeFirstResponder()
        
        submitTimes = 0

        resetTime()
    }

    
    func startCountingTime() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GamePlayViewController.updateTime), userInfo: nil, repeats: true)
        timeKeepCounting.hidden = false
        lastSubmitTime.hidden = false
    }
    
    
    func updateTime() {
        timeCount += 0.01
        timeCount = Double(round(1000*timeCount)/1000)
        timeKeepCounting.text = "\(timeCount)"
    }
    
    func updateSubmitTime() {
        lastSubmitTime.text = "\(timeCount)"
    }
    
    func stopTime() {
        timer.invalidate()
        timeKeepCounting.text = "\(timeCount)"
        lastSubmitTime.text = "\(timeCount)"
    }
    
    func resetTime() {
        timer.invalidate()
        timeCount = 0
        timeKeepCounting.text = "\(timeCount)"
        timeKeepCounting.hidden = true
        lastSubmitTime.hidden = true
    }
    
    
    func getLast10Records() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "GamePlayTimeRecords")
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [GamePlayTimeRecords]
            
            for result in results {
                guard let record = result.record as? Double
                    else {
                        continue
                }
                self.historyRecords.append(record)
            }
            
        } catch {
            return
        }
        
        let offset = max(historyRecords.count - 10, 0)
        var temp = historyRecords
        
        guard offset != 0
        else {
            last10records = historyRecords
            return
        }
        
        for _ in 1...offset {
            last10records.append(temp.last!)
            temp.removeLast(1)
        }
    }
    
    
    func updateGamePlayTime(newRecord: Double) {
        
        self.gamePlayTime.append(newRecord)
        
        guard self.last10records.count >= 10
            else {
                self.last10records.append(newRecord)
                updateAverage(self.last10records)
                return
        }
        
        self.last10records.removeAtIndex(0)
        self.last10records.append(newRecord)
        updateAverage(self.last10records)
    }

    
    func updateAverage(last10: [Double]) {
        let sum = last10records.reduce(0, combine: +)
        let ave = round( (sum / Double(last10records.count) * 1000) / 1000)
        historyRecordsAve.text = "Ave. time of last 10 \nplays : \(ave) sec"
    }
}
