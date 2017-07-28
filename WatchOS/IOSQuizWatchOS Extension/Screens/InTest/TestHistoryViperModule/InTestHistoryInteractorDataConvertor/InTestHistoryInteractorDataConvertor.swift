//
//  InTestHistoryInteractorDataConvertor.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct InTestHistoryInteractorDataConvertor {
    func inTestInterfaceControllerSetting(from historyResult: QuizTestHistoryResult) -> InTestInterfaceControllerSetting {
        let questionText = historyResult.question
        var inTestRowSettings = [InTestRowControllerSetting]()
        
        for (index, answerText) in historyResult.answers.enumerated() {
            var markType: InTestRowcontrollerAnswerMarkType?
            
            if index == historyResult.userAnswer && index == historyResult.rightAnswer {
                markType = InTestRowcontrollerAnswerMarkType.rightAnswer
            } else if index == historyResult.userAnswer {
                markType = InTestRowcontrollerAnswerMarkType.wrongAnswer
            } else if index == historyResult.rightAnswer {
                markType = InTestRowcontrollerAnswerMarkType.rightAnswer
            }
            
            let rowSetting = InTestRowControllerSetting(answerText: answerText, id: nil, answerMark: markType)
            
            inTestRowSettings.append(rowSetting)
        }
        
        return InTestInterfaceControllerSetting(questionText: questionText, rowControllerSettings: inTestRowSettings)
    }
}
