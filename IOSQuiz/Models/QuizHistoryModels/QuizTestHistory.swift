//
//  QuizTestHistory.swift
//  IOSQuiz
//
//  Created by galushka on 6/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct QuizTestHistory: Codable {
    let date: Int
    let results: [QuizTestHistoryResult]
    
    let categoryName: String
    
    init(from quizTestAnswers: [QuizTestAnswer], categoryName: String, date: Int) {
        self.date = date
        self.categoryName = categoryName
        
        let results = quizTestAnswers.map { (answer) -> QuizTestHistoryResult in
            let userAnswer = answer.userAnswer
            let answers = answer.question.answers
            let rightAnswer = answer.question.rightAnswer
            let question = answer.question.questionText
            
            return QuizTestHistoryResult(userAnswer: userAnswer,
                                         answers: answers,
                                         rightAnswer: rightAnswer,
                                         question: question)
        }
        
        self.results = results
    }
    
    init(date: Int, categoryName: String, quizTestResults: [QuizTestHistoryResult]) {
        self.date = date
        self.results = quizTestResults
        self.categoryName = categoryName
    }
}
