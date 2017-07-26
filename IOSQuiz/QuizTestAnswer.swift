//
//  QuizTestAnswer.swift
//  IOSQuiz
//
//  Created by galushka on 6/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct QuizTestAnswer: Codable, Hashable {
    static func ==(lhs: QuizTestAnswer, rhs: QuizTestAnswer) -> Bool {
        if lhs.question.answers.count != rhs.question.answers.count,
           lhs.question.categoryID != rhs.question.categoryID,
           lhs.question.questionText != rhs.question.questionText,
           lhs.question.rightAnswer != rhs.question.rightAnswer,
           lhs.userAnswer != lhs.userAnswer {
            return false
        }
        
        for (index, answer) in lhs.question.answers.enumerated() {
            if lhs.question.answers[index] != answer {
                return false
            }
        }
        
        return true
    }
    
    var hashValue: Int {
        let answersHash = question.answers.reduce(0) { (result, answer) -> Int in result + answer.hash }
        
        let categoryHash = question.categoryID.hash
        let questionTextHash = question.questionText.hash
        let rightAnswerHash = question.rightAnswer.hashValue
        let questionIDHash = question.questionID.hashValue
        
        return (answersHash + categoryHash + questionTextHash + rightAnswerHash + questionIDHash + userAnswer.hashValue)
    }
    
    let question: QuizTestQuestion
    let userAnswer: Int
}


