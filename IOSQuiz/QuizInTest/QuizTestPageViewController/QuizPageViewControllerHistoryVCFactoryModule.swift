//
//  QuizPageViewControllerHistoryVCFactoryModule.swift
//  IOSQuiz
//
//  Created by galushka on 6/22/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit


class QuizPageViewControllerHistoryVCFactoryModule {
    
    let historyResults: [QuizTestHistoryResult]
    let viewControllersCount: Int
    var currentViewControllerIndex: Int
    
    var currentViewController: QuizTestQuestionViewController?
    var nextViewController: QuizTestQuestionViewController?
    var prevViewController: QuizTestQuestionViewController?
    
    init(historyResults: [QuizTestHistoryResult], beginState: Int) {
        self.historyResults = historyResults
        self.viewControllersCount = historyResults.count
        self.currentViewControllerIndex = beginState
        
        currentViewController = quizTestQuestionViewController(fromIndex: currentViewControllerIndex)
        nextViewController = quizTestQuestionViewController(fromIndex: currentViewControllerIndex + 1)
        prevViewController = quizTestQuestionViewController(fromIndex: currentViewControllerIndex - 1)
    }
    
    func stepForward() {
        let lastElement = (historyResults.count - 1)
        
        if currentViewControllerIndex < lastElement {
            
            currentViewControllerIndex += 1
            
            prevViewController = currentViewController
            currentViewController = nextViewController
            nextViewController = quizTestQuestionViewController(fromIndex: currentViewControllerIndex + 1)
            
        }
    }
    
    func stepBack() {
        
        if currentViewControllerIndex > 0 {
            
            currentViewControllerIndex -= 1
            
            nextViewController = currentViewController
            currentViewController = prevViewController
            prevViewController = quizTestQuestionViewController(fromIndex: currentViewControllerIndex - 1)
        }
    }
    
    func quizTestQuestionViewController(fromIndex index: Int) -> QuizTestQuestionViewController? {
        
        if index >= 0 && index <= (historyResults.count - 1) {
            let quizTestQuestionViewControllerSettings = QuizTestQuestionViewControllerSettings.history(quizTestHistoryResult: historyResults[index])
            
            let questionViewController = QuizTestQuestionViewController(from: quizTestQuestionViewControllerSettings)
            questionViewController.index = index
            
            return questionViewController
        }
        
        return nil
    }
}
