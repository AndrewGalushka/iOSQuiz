//
//  InTestDataStorage.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class InTestDataStorage {
    private(set) var testAnswers = [QuizTestAnswer]()
    var answersCount: Int {
       return testAnswers.count
    }
    
    func addAnswer(_ answer: QuizTestAnswer) {
        for (index, savedAnswer) in testAnswers.enumerated() {
            if isAnswersFromSameCategory(first: savedAnswer, seconds: answer) {
                testAnswers[index] = answer
                return
            }
        }
        
        testAnswers.append(answer)
    }
    
    private func isAnswersFromSameCategory(first firstAnswer: QuizTestAnswer, seconds secondAnswer: QuizTestAnswer) -> Bool {
        if firstAnswer.question == secondAnswer.question {
            return true
        }
        
        return false
    }
}
