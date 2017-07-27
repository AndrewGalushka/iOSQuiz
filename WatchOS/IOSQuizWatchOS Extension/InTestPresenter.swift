//
//  InTestModule.swift
//  IOSQuiz
//
//  Created by galushka on 7/11/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum WCInTestPresentorMode {
    case normalTest
    case challengeTest
}

enum WCInTestPresenterFinishTestEvent {
    case timeLeft
    case wrongAnswer
    case lastAnswer
    case forceQuit
}

protocol WCInTestPresenterInput {
    weak var view: InTestView? { get set }
    
    func didAppear(view: InTestView)
    func willDisappear()
    
    func addAnswer(answerText: String)
}

class WCInTestPresenter {
    weak var view: InTestView?
    private var interactor: WCInTestInteractorInput
    private let dataConvertor = InTestDataConvertor()
    private let timer: QuizTimer?
    private let mode: WCInTestPresentorMode
    var questionsCount: Int? = nil
    
    init(testMode mode: WCInTestPresentorMode, interactor: WCInTestInteractorInput) {
        self.interactor = interactor
        self.mode = mode
        
        switch mode {
        case .normalTest:
            timer = QuizTimer(startingTime: 300)
            timer?.delegate = self
        case .challengeTest:
            timer = QuizTimer(startingTime: 10)
            timer?.delegate = self
        }
    }
    
    private func question(byIndex index: UInt) {
        interactor.requestQuestion(byIndex: index)
    }
}

extension WCInTestPresenter: WCInTestPresenterInput {
    
    func addAnswer(answerText: String) {
        guard let questionNumber = view?.questionNumber else { return }
        
        interactor.retrieveQuestion(byIndex: questionNumber, resultClosure: { [weak self] (question) in
            guard let strongSelf = self else { return }
            
            guard let quizAnswer = strongSelf.dataConvertor.quizTestAnswer(fromAnswerText: answerText, question: question) else {
                print("strongSelf.dataConvertor.quizTestAnswer(fromAnswerText: answerText, question: question)")
                strongSelf.view?.finishTest(withEvent: .forceQuit)
                return
            }
            
            if strongSelf.mode == .challengeTest {
                guard strongSelf.isAnswerCorrect(quizAnswer, question: question) else {
                    strongSelf.view?.finishTest(withEvent: .wrongAnswer)
                    return
                }
            }
            
            strongSelf.interactor.addAnswer(quizAnswer)
            
            guard let questionsCount = strongSelf.questionsCount else {
                strongSelf.view?.finishTest(withEvent: .forceQuit)
                return
            }
            
            if strongSelf.interactor.savedAnswersCount() == questionsCount {
                strongSelf.interactor.postHistory()
                strongSelf.view?.finishTest(withEvent: .lastAnswer)
                return
            }
            
        }, errorClosure: {
        })
    }
    
    private func isAnswerCorrect(_ answer: QuizTestAnswer, question: QuizTestQuestion) -> Bool {
        if answer.userAnswer == question.rightAnswer {
            return true
        } else {
            return false
        }
    }
    
    func didAppear(view: InTestView) {
        self.view = view
        
        let index = view.questionNumber
        interactor.requestQuestion(byIndex: index)
        timer?.start()
    }
    
    func willDisappear() {
        view = nil
    }
}

extension WCInTestPresenter: WCInTestInteractorOutput {
    func receiveQuestion(_ question: QuizTestQuestion) {
        if let view = self.view {
            let setting = dataConvertor.questionResultToInTestControllerSetting(question)
            view.showQuestion(setting: setting)
        }
    }
}

extension WCInTestPresenter: QuizTimerDelegate {
    func timerFire(time: UInt) {
        if let view = self.view {
            let timeString = dataConvertor.convertUIntToTimeString(time)
            view.changeTimerTime(timeString)
        }
    }
    
    func finished() {
        view?.finishTest(withEvent: .timeLeft)
    }
}
