//
//  QuizPostHistoryModel.swift
//  IOSQuiz
//
//  Created by galushka on 6/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct QuizPostHistoryModel: Codable {
    let categoryName: String
    let date: Int
    let questions: [QuizPostHistoryAnswerModel]
    
    init(from answers: [QuizTestAnswer], date: Int, categoryName: String) {
        
        self.categoryName = categoryName
        self.date = date
        
        let questions = answers.map {
            QuizPostHistoryAnswerModel(userAnswer: $0.userAnswer, questionId: $0.question.questionID)
        }
        
        self.questions = questions
    }
}
