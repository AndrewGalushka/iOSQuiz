//
//  Interactor.swift
//  IOSQuiz
//
//  Created by galushka on 7/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WCInTestInteractorInput {
    func requestQuestion(byIndex index: UInt)
    func retrieveQuestion(byIndex index: UInt,
                          resultClosure: @escaping (_ question: QuizTestQuestion) -> Void,
                          errorClosure: @escaping () -> Void)
    func addAnswer(_ quizTestAnswer: QuizTestAnswer)
    func savedAnswersCount() -> Int
    func postHistory()
}
