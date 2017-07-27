//
//  QuizTestHistoryResult.swift
//  IOSQuiz
//
//  Created by galushka on 6/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct QuizTestHistoryResult: Codable {
    let userAnswer: Int
    let answers: [String]
    let rightAnswer: Int
    let question: String
}

class QuizTestHistoryResultCoreData: NSObject, NSCoding {
    
    let userAnswer: Int
    let answers: [String]
    let rightAnswer: Int
    let question: String
    
    init(quizTestHistoryResult: QuizTestHistoryResult) {
        self.userAnswer = quizTestHistoryResult.userAnswer
        self.answers = quizTestHistoryResult.answers
        self.rightAnswer = quizTestHistoryResult.rightAnswer
        self.question = quizTestHistoryResult.question
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userAnswer, forKey: "userAnswer")
        aCoder.encode(self.answers, forKey: "answers")
        aCoder.encode(self.rightAnswer, forKey: "rightAnswer")
        aCoder.encode(self.question, forKey: "question")
    }
    
    init(userAnswer: Int, answers: [String], rightAnswer: Int, question: String) {
        self.userAnswer = userAnswer
        self.answers = answers
        self.rightAnswer = rightAnswer
        self.question = question
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        guard
            let answers = aDecoder.decodeObject(forKey: "answers") as? [String],
            let question = aDecoder.decodeObject(forKey: "question") as? String
            else {
                return nil
        }
        
        let userAnswer = aDecoder.decodeInteger(forKey: "userAnswer")
        let rightAnswer = aDecoder.decodeInteger(forKey: "rightAnswer")
        
        self.init(userAnswer: Int(userAnswer),
                  answers: answers,
                  rightAnswer: rightAnswer,
                  question: question)
    }
    
    func quizTestHistoryResult() -> QuizTestHistoryResult {
        return QuizTestHistoryResult(userAnswer: userAnswer,
                                     answers: answers,
                                     rightAnswer: rightAnswer,
                                     question: question)
    }
}
