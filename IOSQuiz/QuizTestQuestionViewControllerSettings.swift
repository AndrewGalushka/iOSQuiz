//
//  QuizTestQuestionViewControllerSettings.swift
//  IOSQuiz
//
//  Created by galushka on 6/22/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

enum SingleQuestionType: Equatable {
    case questionID(questionID: String)
    case randomQuestion
    
    static func ==(lhs: SingleQuestionType, rhs: SingleQuestionType) -> Bool {
        switch (lhs, rhs) {
        case (questionID(_), questionID(_)):
            return true
        case (randomQuestion, randomQuestion):
            return true
        default:
            return false
        }
    }
}

enum QuizTestQuestionViewControllerSettings: Equatable {
    case test(quizTestQuestion: QuizTestQuestion)
    case history(quizTestHistoryResult: QuizTestHistoryResult)
    case singleQuestion(type: SingleQuestionType)
    
    static func ==(lhs: QuizTestQuestionViewControllerSettings, rhs: QuizTestQuestionViewControllerSettings) -> Bool {
        switch (lhs, rhs) {
        case (test(_), test(_)):
            return true
        case (history(_), history(_)):
            return true
        case (singleQuestion, singleQuestion):
            return true
        default:
            return false
        }
    }
}

