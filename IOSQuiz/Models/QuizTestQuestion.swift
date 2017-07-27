//
//  QuizTestQuestion.swift
//  IOSQuiz
//
//  Created by galushka on 6/9/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct QuizTestQuestion: Codable {
    let questionText: String
    let answers: [String]
    
    let rightAnswer: Int
    
    let categoryID: String
    let questionID: String
    
    static func emptyQuestion() -> QuizTestQuestion {
        return QuizTestQuestion(questionText: "empty",
                                answers: ["empty1", "empty2", "empty2"],
                                rightAnswer: 1,
                                categoryID: "emptyCategoryID",
                                questionID: "emptyQuestionID")
    }
}

extension QuizTestQuestion: Equatable {
    
    static func ==(lhs: QuizTestQuestion, rhs: QuizTestQuestion) -> Bool {
        
        if  lhs.answers.count != rhs.answers.count,
            lhs.questionText  != rhs.questionText,
            lhs.rightAnswer != rhs.rightAnswer {
            return false
        }
        
        
        for (index, answer) in lhs.answers.enumerated() {
            if answer != rhs.answers[index] {
                return false
            }
        }
        
        return true
    }
}
