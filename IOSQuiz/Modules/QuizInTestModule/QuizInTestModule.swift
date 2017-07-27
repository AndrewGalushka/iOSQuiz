//
//  File.swift
//  IOSQuiz
//
//  Created by galushka on 6/9/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

enum QuizInTestModuleMode {
    case test
    case challenge
}

enum QuizInTestModuleResult{
    case successful
    
    case notConnectedToInternet
    case cantConnectToServer
    
    case unknownError
    
    func isResultFromServer() -> Bool {
        if self == .cantConnectToServer || self == .notConnectedToInternet {
            return false
        }
        
        return true
    }
}

protocol QuizInTestModuleType {

    var currentQuestionIterator: Int {set get}
    
    func currentQuestion(_ result: @escaping (_ result: QuizInTestModuleResult, _ question: QuizTestQuestion?) -> Void)
    func nextQuestion(_ result: @escaping (_ result: QuizInTestModuleResult, _ question: QuizTestQuestion?) -> Void)
    func questionsStepNext()
    
    func addAnswer(_ answer: QuizTestAnswer)
    
    func isQuestion(_ question: QuizTestQuestion, containAnswer answer: String) -> Bool
    func answerNumber(fromQuestion question: QuizTestQuestion, answerText: String) -> Int?
}

class QuizInTestModule: QuizInTestModuleType, QuizTestFinishTestDelegate {
    
    let serverManager = QuizServerManager()
    
    let category: QuizTestCategory
    var answers = [QuizTestAnswer]()
    var currentQuestionIterator = 0
    
    var quizInTestModuleDelegate: QuizInTestModuleDelegate?
    var timer: Timer?
    var timerStartCount: Int
    var timerCurrentSeconds: Int?
    
    let mode: QuizInTestModuleMode
    
    var currentQuestion: QuizTestQuestion?
    var nextQuestion: QuizTestQuestion?
    
    let normalModeTimerStartCount = 300
    let challengeModeTimerStartCount = 10
    
    init(testCategory: QuizTestCategory, mode: QuizInTestModuleMode = .test) {
        self.mode = mode
        category = testCategory
        
        switch mode {
        case .test:
            timerStartCount = normalModeTimerStartCount
        case .challenge:
            timerStartCount = challengeModeTimerStartCount
        }
    }
    
    func addAnswer(_ answer: QuizTestAnswer) {
        
        if mode == .challenge {
            if isAnswerCorrect(answer) {
                resetTimer()
            } else {
                finishTest(event: .wrongAnswer)
            }
        }
        
        answers.append(answer)
    }
    
    func currentQuestion(_ result: @escaping (_ responseResult: QuizInTestModuleResult, _ question: QuizTestQuestion?) -> Void) {
        
        question(withOffset: currentQuestionIterator) { [weak self] (responseResult, question) in
            if responseResult == .successful{
                self?.currentQuestion = question
            } else {
                self?.currentQuestion = nil
            }
            
            result(responseResult, question)
        }
    }
    
    func nextQuestion(_ result: @escaping (_ result: QuizInTestModuleResult, _ question: QuizTestQuestion?) -> Void) {
        let nextQuestionIterator = currentQuestionIterator + 1
        
        question(withOffset: nextQuestionIterator) { [weak self] (responseResult, question) in
            if responseResult == .successful{
                self?.nextQuestion = question
            } else {
                self?.currentQuestion = nil
            }
            
            result(responseResult, question)
        }
    }
    
    func nextQuestionWithStep(_ result: @escaping (_ result: QuizInTestModuleResult, _ question: QuizTestQuestion?) -> Void) {
        questionsStepNext()
        
        currentQuestion = nextQuestion
        let nextQuestionIterator = currentQuestionIterator + 1
        
        question(withOffset: nextQuestionIterator) { [weak self] (responseResult, question) in
            if responseResult == .successful{
                self?.nextQuestion = question
            } else {
                self?.currentQuestion = nil
            }
            
            result(responseResult, question)
        }
    }
    
    func questionsStepNext() {
        currentQuestionIterator += 1
    }
    
    func isQuestion(_ question: QuizTestQuestion, containAnswer answer: String) -> Bool {
        
        for collectedAnswer in question.answers {
            
            if answer ==  collectedAnswer {
                return true
            }
        }
        
        return false
    }
    
    func answerNumber(fromQuestion question: QuizTestQuestion, answerText: String) -> Int? {
        
        for (index, element) in question.answers.enumerated() {
            
            if element == answerText {
                return index
            }
            
        }
        
        return nil
    }
    
    func setUpTimer() {
        timerCurrentSeconds = timerStartCount
        timer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        
        quizInTestModuleDelegate?.timerFire(secondsLeft: timerStartCount)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    func startTest() {
        setUpTimer()
    }
    
    @objc func timerFire() {
        
        guard var fetchedCurrentSecondsMinusOne = timerCurrentSeconds else {
            return
        }
        
        fetchedCurrentSecondsMinusOne -= 1
        
        timerCurrentSeconds = fetchedCurrentSecondsMinusOne
        quizInTestModuleDelegate?.timerFire(secondsLeft: fetchedCurrentSecondsMinusOne)
        
        if fetchedCurrentSecondsMinusOne == 0 {
            shutDownTimer()
            quizInTestModuleDelegate?.stopTest(stopedEvent: .timeLeft)
        }
    }
    
    func finishTest(event: QuizInTestModuleStopEventType) {
        
        if event == .lastAnswer {
            saveAnswers()
        }
        
        shutDownTimer()
    
        quizInTestModuleDelegate?.stopTest(stopedEvent: event)
    }
    
    func shutDownTimer() {
        
        if timer != nil {
            timer?.invalidate()
        }
    }
    
    private func ifServerResponseStatusFromURLSessionConvert(toQuizInTestModuleResult serverResponseStatus: QuizServerResponse) -> QuizInTestModuleResult? {
        
        if serverResponseStatus.isResponseFromServer() == false {
            
            if serverResponseStatus == .cantConnectToServer {
                return .cantConnectToServer
            } else {
                return .notConnectedToInternet
            }
        } else {
            return nil
        }
    }
    
    private func question(withOffset: Int, result: @escaping (_ result: QuizInTestModuleResult, _ question: QuizTestQuestion?) -> Void) {
        
        serverManager.questions(fromCategoryID: category.categoryID, offset: withOffset, pageSize: 1) { [weak self] (reponse, questions) in
            
            if let urlSessionResponse = self?.ifServerResponseStatusFromURLSessionConvert(toQuizInTestModuleResult: reponse) {
                result(urlSessionResponse, nil)
            }
            
            if reponse == .successful {
                
                guard let fetchedQuestions = questions else {
                    result( .unknownError, nil)
                    return
                }
                
                result(.successful, fetchedQuestions.first)
                
            } else {
                result(.unknownError, nil)
            }
        }
    }
    
    func resetTimer() {
        stopTimer()
        quizInTestModuleDelegate?.timerFire(secondsLeft: 10)
        resetTimerTime()
        startTimer()
    }
    
    func resetTimerTime() {
        timerCurrentSeconds = timerStartCount
    }
    
    private func saveAnswers() {
        postHistoryToServer()
        addHistoryToDataBase()
    }
    
    func postHistoryToServer() {
        
        let date = Date().timeIntervalSince1970
        
        let quizPostHistoryModel = QuizPostHistoryModel(from: self.answers,
                                                        date: Int(date),
                                                        categoryName: category.categoryName)
        
        serverManager.postHistory(quizPostHistoryModel) {(responseCode, errorLog) in
            
        }
    }
    
    func addHistoryToDataBase() {
            let date = Date().timeIntervalSince1970
            
            let quizHistory = QuizTestHistory(from: answers,
                                              categoryName: category.categoryName,
                                              date: Int(date))
            
            QuizCoreDataBase().addHistory(quizHistory)
    }
    
    func isAnswerCorrect(_ answer: QuizTestAnswer) -> Bool {
        guard let fetchedCurrentQuestion = currentQuestion else {
            return false
        }
        
        return (answer.userAnswer == fetchedCurrentQuestion.rightAnswer)
    }
    
    func startTimer() {
        setUpTimer()
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
        }
    }
}
