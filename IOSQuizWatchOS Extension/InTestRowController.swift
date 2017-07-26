//
//  InTestInterfaceTable.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

enum InTestRowcontrollerAnswerMarkType {
    case wrongAnswer
    case rightAnswer
}

struct InTestRowControllerSetting {
    let answerText: String
    let id: String?
    let answerMark: InTestRowcontrollerAnswerMarkType?
    
    init(answerText: String, id: String?, answerMark: InTestRowcontrollerAnswerMarkType?) {
        self.id = id
        self.answerText = answerText
        self.answerMark = answerMark
    }
}

class InTestRowController: NSObject {
    @IBOutlet var answerLabel: WKInterfaceLabel!
    @IBOutlet var rowGroup: WKInterfaceGroup!
    
    var id: String = ""
    
    func showMark(_ markType: InTestRowcontrollerAnswerMarkType) {
        switch markType {
        case .wrongAnswer:
            showWrongAnswerMark()
        case .rightAnswer:
            showRightAnswerMark()
        }
    }
    
    private func showWrongAnswerMark() {
        DispatchQueue.main.async { [ weak self ] in
            self?.rowGroup.setBackgroundColor(.red)
        }
    }
    
    private func showRightAnswerMark() {
        DispatchQueue.main.async { [ weak self ] in
             self?.rowGroup.setBackgroundColor(UIColor.green)
        }
        
    }
    
    func unmarkRow() {
        DispatchQueue.main.async { [ weak self ] in
            self?.rowGroup.setBackgroundColor(.orange)
        }
    }
    
    func configure(setting: InTestRowControllerSetting) {
        if let id = setting.id {
            self.id = id
        }
        
        if let markType = setting.answerMark {
            showMark(markType)
        }
        
        self.answerLabel.setText(setting.answerText)
    }
}
