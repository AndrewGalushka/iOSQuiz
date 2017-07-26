//
//  InTestIntefaceController.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

fileprivate let interfaceTableAnswerRowID = "AnswerRow"

class InTestInterfaceController: WKInterfaceController {
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var answersTableView: WKInterfaceTable!
    @IBOutlet var questionTextLabel: WKInterfaceLabel!
    @IBOutlet var timeLeftStaticTextLabel: WKInterfaceLabel!
    
    var questionNumber: UInt = 10
    weak var sharedTestPresentor: WCInTestPresenter?
    weak var sharedHistoryPresentor: WCInTestHistoryPresenter?
    
    let wkQuizAlerts = WKQuizAlerts()
    
    var isControllerSetted = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        obtainControllerData(fromContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        if sharedHistoryPresentor != nil {
            timeLeftStaticTextLabel.setHidden(true)
        }
    }
    
    override func willDisappear() {
        
        if sharedTestPresentor != nil {
            timerLabel.setText(nil)
            sharedTestPresentor?.willDisappear()
        } else if sharedHistoryPresentor != nil {
            sharedHistoryPresentor?.willDisappear()
        }
    }
    
    override func didAppear() {
        super.didAppear()
        
        if !isControllerSetted {
            if sharedTestPresentor != nil {
                sharedTestPresentor?.didAppear(view: self)
            } else if sharedHistoryPresentor != nil {
                sharedHistoryPresentor?.didAppear(view: self)
            }
        }
    }
    
    private func obtainControllerData(fromContext context: Any?) {
        guard let context = context as? [String: Any] else {
            self.dismiss()
            return
        }
        
        guard let questionNumber = context["id"] as? UInt else {
            self.dismiss()
            return
        }
        
        if let inTestPresenter = context["presenter"] as? WCInTestPresenter {
            sharedTestPresentor = inTestPresenter
        } else if let inTestHistoryPresenter = context["presenter"] as? WCInTestHistoryPresenter {
            sharedHistoryPresentor = inTestHistoryPresenter
        } else {
            return
        }
        
        self.questionNumber = questionNumber
    }
}

extension InTestInterfaceController: InTestView {
    func showQuestion(setting: InTestInterfaceControllerSetting) {
        setUpController(from: setting)
    }
    
    func dataProvidingFailed(failureType: WatchSessionDataFailure) {
    }
    
    func finishTest(withEvent event: WCInTestPresenterFinishTestEvent) {
        switch event {
        case .forceQuit:
            self.dismiss()
        case .lastAnswer:
            wkQuizAlerts.presentInformAlert(on: self, informAlertType: .testSuccessEnd, actionClosure: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismiss()
            })
        case .timeLeft:
            wkQuizAlerts.presentInformAlert(on: self, informAlertType: .testTimeLeft, actionClosure: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismiss()
            })
        case .wrongAnswer:
            wkQuizAlerts.presentInformAlert(on: self, informAlertType: .testWrongAnswer, actionClosure: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismiss()
            })
        }
    }
    
    func changeTimerTime(_ time: String) {
        timerLabel.setText(time)
    }
}

extension InTestInterfaceController: InTestHistoryView {
    func showHistoryResult(setting: InTestInterfaceControllerSetting) {
        setUpController(from: setting)
    }
}

extension InTestInterfaceController {
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard sharedTestPresentor != nil else { return }
        
        guard let clickedRow = table.rowController(at: rowIndex) as? InTestRowController else {
            return
        }
        
        clickedRow.showMark(.rightAnswer)
        sharedTestPresentor?.addAnswer(answerText: clickedRow.id)
        
        for index in 0..<table.numberOfRows {
            guard let row = table.rowController(at: index) as? InTestRowController else {
                continue
            }
            
            if clickedRow == row {
                continue
            }
            
            row.unmarkRow()
        }
    }
}

// setUp
extension InTestInterfaceController {
    
    func setUpController(from setting: InTestInterfaceControllerSetting) {
        questionTextLabel.setText(setting.questionText)
        setUpTable(from: setting.rowControllerSettings)
        
        isControllerSetted = true
        print("isControllerSetted = true")
    }
    
    func setUpTable(from rowSettings: [InTestRowControllerSetting]) {
        answersTableView.setNumberOfRows(rowSettings.count, withRowType: interfaceTableAnswerRowID)
        
        for (index, value) in rowSettings.enumerated() {
            guard let row = answersTableView.rowController(at: index) as? InTestRowController else { continue }
            row.configure(setting: value)
        }
    }
}
