//
//  QuizPageViewControllerTestModule.swift
//  IOSQuiz
//
//  Created by galushka on 6/16/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class QuizPageViewControllerTestVCFactoryModule {
    
    var currentQuestion: QuizTestQuestion? {
        return quizInTestModule?.currentQuestion
    }
    
    var nextQuestion: QuizTestQuestion? {
        return quizInTestModule?.nextQuestion
    }
    
    weak var quizInTestModule: QuizInTestModule?
    
    func setUpFirstControllers(from quizInTestModule: QuizInTestModule, complition: @escaping (_ result: QuizInTestModuleResult, _ firstViewController: QuizTestQuestionViewController?) -> Void) {
        
        self.quizInTestModule = quizInTestModule
        
        self.quizInTestModule?.currentQuestion { [weak self] (downloadResult, currentQuestion) in
            
            if (downloadResult != .successful) {
                if !downloadResult.isResultFromServer() {
                    complition(downloadResult, nil)
                } else {
                    complition(.unknownError, nil)
                }
            }
            
            self?.quizInTestModule?.nextQuestion({ (downloadResult, nextQuestion) in
                
                if (downloadResult != .successful) {
                    if !downloadResult.isResultFromServer() {
                        complition(downloadResult, nil)
                    } else {
                        complition(.unknownError, nil)
                    }
                }
            
                if let fetchedCurrentQuestion = self?.quizInTestModule?.currentQuestion {
                    
                    let questionViewControllerSettings = QuizTestQuestionViewControllerSettings.test(quizTestQuestion: fetchedCurrentQuestion)
                    let firstViewController = QuizTestQuestionViewController(from: questionViewControllerSettings)
                    complition(.successful, firstViewController)
                    
                    return
                }
            })
        }
    }
    
    func stepNextViewController(complition: @escaping (_ result: QuizInTestModuleResult) -> Void) {
        quizInTestModule?.nextQuestionWithStep{ (result, question) in
            complition(result)
        }
    }
    
    func currentViewController() -> QuizTestQuestionViewController? {
        
        if let fetchedCurrentQuestion = self.quizInTestModule?.currentQuestion {
            
            let questionViewControllerSettings = QuizTestQuestionViewControllerSettings.test(quizTestQuestion: fetchedCurrentQuestion)
            let currentViewController = QuizTestQuestionViewController(from: questionViewControllerSettings)
            
            return currentViewController
        }
        
        return nil
    }
    
    func nextViewController() -> QuizTestQuestionViewController? {
        
        if let fetchdNextQuestion = self.quizInTestModule?.nextQuestion {
            let questionViewControllerSettings = QuizTestQuestionViewControllerSettings.test(quizTestQuestion: fetchdNextQuestion)
            let nextViewController = QuizTestQuestionViewController(from: questionViewControllerSettings)
            
            return nextViewController
        }
        
        return nil
    }
}
