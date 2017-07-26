//
//  InTestIntercatorDataConvertor.swift
//  IOSQuiz
//
//  Created by galushka on 7/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct InTestDataConvertor {
    func  questionResultToInTestControllerSetting(_ quizTestQuestion: QuizTestQuestion) -> InTestInterfaceControllerSetting {
        let rowControllerSettings = quizTestQuestion.answers.map {
            InTestRowControllerSetting(answerText: $0, id: $0, answerMark: nil)
        }
        
        let questionText = quizTestQuestion.questionText
        
        return InTestInterfaceControllerSetting(questionText: questionText, rowControllerSettings: rowControllerSettings)
    }
    
    func convertUIntToTimeString(_ seconds: UInt) -> String {
        let (_, minutes, seconds) = convert(secondsToHoursMinutesSeconds: Int(seconds))
        
        let secondsString = seconds >= 10 ? String(seconds) : "0\(seconds)"
        let minutesString = minutes >= 10 ? String(seconds) : "0\(minutes)"
        
        return minutesString + ":" + secondsString
    }
    
    func quizTestAnswer(fromAnswerText answerText: String, question: QuizTestQuestion) -> QuizTestAnswer? {
        for (index, answer) in question.answers.enumerated() {
            if answerText == answer {
                let quizTestAnswer = QuizTestAnswer(question: question, userAnswer: index)
                return quizTestAnswer
            }
        }
        
        return nil
    }
}
