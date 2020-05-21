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
    private let returnButton = UIButton(type: .custom)
    private var submitTimes: Int = 0
    private var timer = Timer()
    private var timeCount: Double = 0
    private var historyRecords: [Double] = [] // records from history, used to get last 10 records
    private var last10records: [Double] = []
    var gamePlayTime: [Double] = [] // records start from today's game play
    

    override func viewDidLoad() {
        super.viewDidLoad()

        getLast10Records()

        inputTextField.delegate = self
        
        outputLabel.textColor = UIColor.darkGray
        
        setupReturnButton()
                
        playNewGame()
        
        replayButton.setTitle(NSLocalizedString("Replay", comment: "Replay"), for: .normal)
        
        timeKeepCounting.isHidden = true
        
        lastSubmitTime.isHidden = true
        
        updateAverage(last10: last10records)
        
        // 點擊其他地方視為結束輸入，回傳key in的資料、隱藏keyboard
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GamePlayViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        inputTextField.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let appDelegate = AppDelegate()
        appDelegate.saveGamePlayTime(playtime: gamePlayTime)
    }
    
    
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    
    func setupReturnButton() {
        returnButton.setTitle("Go", for: .normal)
        returnButton.setTitleColor(UIColor.white, for: .normal)
        returnButton.contentHorizontalAlignment = .center
        returnButton.frame = CGRect(x: 0, y: 163, width: self.view.frame.width / 3 , height: 53)
        returnButton.titleLabel?.adjustsFontSizeToFitWidth = true
        returnButton.addTarget(self, action: #selector(go(sender:)), for: .touchUpInside)
    }
    
    
    @objc func go(sender: UIButton) {
        didTapView()
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 4
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let currentText = textField.text!
        
        checkAnswerType(currentText: currentText,
            
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
                    self.gameDescription.text = NSLocalizedString("GAME START!!", comment: "GAME START!!")
                    self.startCountingTime()
                    break
                    
                case 5:
                    self.gameDescription.text = NSLocalizedString("Keep on going! \nYou're almost there", comment: "Keep on going! \nYou're almost there")
                    break
                    
                case 8:
                    self.gameDescription.text = NSLocalizedString("Wanna give up? \nCome on you can do this", comment: "Wanna give up? \nCome on you can do this")
                    break
                    
                case 12:
                    self.gameDescription.text = NSLocalizedString("You should practice more...", comment: "You should practice more...")
                    return
                    
                default: break
                }
                
                self.updateSubmitTime()
                
                if theResult == "4A0B" {
                    self.gameDescription.text = NSLocalizedString("You WIN! \n Congratulation", comment: "You WIN! \n Congratulation")
                    self.stopTime()
                    self.updateGamePlayTime(newRecord: self.timeCount)
                }
                
            },
            
            incorrect: { error in
                
                switch error {
                
                case .LessThan4:
                    self.errorDescription.text = NSLocalizedString("Less than 4 numbers!", comment: "Less than 4 numbers!")
                    self.inputTextField.text = nil
                    self.inputTextField.becomeFirstResponder()
                    break
                    
                case .DuplicateNumber:
                    self.errorDescription.text = NSLocalizedString("Duplicate number!", comment: "Duplicate number!")
                    self.inputTextField.text = nil
                    self.inputTextField.becomeFirstResponder()
                    break
                }
            }
                
            
        )
        
    }
    
    
    
    @objc func keyboardWillShow(note : NSNotification) -> Void{
        DispatchQueue.main.async {
            self.returnButton.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.returnButton.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: self.view.frame.width / 3 , height: 53)
            keyBoardWindow?.addSubview(self.returnButton)
            keyBoardWindow?.bringSubviewToFront(self.returnButton)
            UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIResponder.keyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
                }, completion: { (complete) -> Void in
            })
        }
    }
    
    
    
    func playNewGame() {
        
        descriptions = NSLocalizedString("Are you ready? \n Enter your first guess below.", comment: "Are you ready? \n Enter your first guess below.")
        gameDescription.text = descriptions
        
        guessingResult = NSLocalizedString("Here're your guessing results:", comment: "Here're your guessing results:")
        outputLabel.text = guessingResult

        answer = answerGenerator()
        print("answer: \(answer)")
        
        inputTextField.becomeFirstResponder()
        
        submitTimes = 0

        resetTime()
    }

    
    func startCountingTime() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timeKeepCounting.isHidden = false
        lastSubmitTime.isHidden = false
    }
    
    
   @objc func updateTime() {
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
        timeKeepCounting.isHidden = true
        lastSubmitTime.isHidden = true
    }
    
    
    func getLast10Records() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GamePlayTimeRecords")
        
        do {
            let results = try managedContext.fetch(request) as! [GamePlayTimeRecords]
            
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
                updateAverage(last10: self.last10records)
                return
        }
        
        self.last10records.remove(at: 0)
        self.last10records.append(newRecord)
        updateAverage(last10: self.last10records)
    }

    
    func updateAverage(last10: [Double]) {
        let sum = last10records.reduce(0, +)
        let ave = round( (sum / Double(last10records.count) * 1000) / 1000)
        historyRecordsAve.text = NSLocalizedString("Ave. time of last 10 \nplays :", comment: "Ave. time of last 10 \nplays :") + " \(ave) " + NSLocalizedString("sec", comment: "sec")
    }
}
