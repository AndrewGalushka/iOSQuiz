//
//  QuizTestPageViewControllerDataSource.swift
//  IOSQuiz
//
//  Created by galushka on 6/16/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

class QuizTestPageViewControllerInTestDataSource: NSObject {
    
    weak var pageViewController: QuizTestPageViewController?
    var transitionFrom = UIViewController()
    
    fileprivate var answer: QuizTestAnswer?
    fileprivate let testVCFactoryModule = QuizPageViewControllerTestVCFactoryModule()
  
    unowned let quizTestModule: QuizInTestModule
    
    init(pageViewController: QuizTestPageViewController, quizInTestModule: QuizInTestModule) {
        self.quizTestModule = quizInTestModule
        self.pageViewController = pageViewController
        
        super.init()
        
        testVCFactoryModule.setUpFirstControllers(from: quizTestModule) { [weak self]
            (result, firstViewController) in
            
            if result == .successful {
                if let fetchedFirstViewController = firstViewController {
                    DispatchQueue.main.async {
                        fetchedFirstViewController.quizPickerTableViewCellDelegate = self
                        
                        self?.pageViewController?.setViewControllers([fetchedFirstViewController], direction: .forward, animated: false, completion: nil)
                        self?.pageViewController?.disableScroll()
                        
                        self?.quizTestModule.quizInTestModuleDelegate = self?.pageViewController
                    }
                }
            }
            
            if !result.isResultFromServer() {
                
                self?.quizTestModule.finishTest(event: .forceStop)
                self?.pageViewController?.presentConnetionTroubleAlert(fromTestModuleResponseResult: result, actionComplition: { [weak self] (action) in
                    self?.pageViewController?.stopTest(stopedEvent: .forceStop)
                })
                
            }

        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    func quizTestAnswer(fromCellID cellID: String) -> QuizTestAnswer? {
        
        guard let fetchedCurrentQuestion = self.testVCFactoryModule.currentQuestion else {
            return nil
        }
        
        if quizTestModule.isQuestion(fetchedCurrentQuestion, containAnswer: cellID) {
            
            let question = fetchedCurrentQuestion
            
            guard let userAnswer = quizTestModule.answerNumber(fromQuestion: fetchedCurrentQuestion, answerText: cellID) else {
                return nil
            }
            
            return QuizTestAnswer(question: question,
                                  userAnswer: userAnswer)
        }
        
        return nil
    }
}

extension QuizTestPageViewControllerInTestDataSource: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            let lastViewController = pageViewController.viewControllers?.last
            
            if transitionFrom != lastViewController {
                
                 self.pageViewController?.disableScroll()
                
                if let fetchedAnswer = self.answer {
                    self.quizTestModule.addAnswer(fetchedAnswer)
                } else {
                    self.quizTestModule.finishTest(event: .forceStop)
                }
                
                testVCFactoryModule.stepNextViewController(complition: { [weak self] (result) in
                    
                    if !result.isResultFromServer() {
                        DispatchQueue.main.async {
                            self?.pageViewController?.presentConnetionTroubleAlert(fromTestModuleResponseResult: result, actionComplition: { (alert) in
                                self?.quizTestModule.finishTest(event: .forceStop)
                            })
                        }
                    }
                    
                    if let currentViewController = self?.testVCFactoryModule.currentViewController() {
                        DispatchQueue.main.async {
                            currentViewController.quizPickerTableViewCellDelegate = self
                            //reload pageViewController
                            self?.pageViewController?.dataSource = nil
                            self?.pageViewController?.dataSource = self
                            //reload pageViewController
                            self?.pageViewController?.disableScroll()
                        }
                    }
                })  
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let lastVC = pageViewController.viewControllers?.last {
            self.transitionFrom = lastVC
        } // if let lastVC = pageViewController.viewControllers?.last
    }
}

extension QuizTestPageViewControllerInTestDataSource: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextTestQuestionViewController = testVCFactoryModule.nextViewController()
        nextTestQuestionViewController?.quizPickerTableViewCellDelegate = self
        
        return nextTestQuestionViewController
    }
}

extension QuizTestPageViewControllerInTestDataSource: QuizPickerTableViewCellDelegate {
    func cellDidClicked(cellID: String) {
        print("QuizTestPageViewController tell: cell with '\(cellID)' ID did clicked")
        
        guard let fetchedAnswer = quizTestAnswer(fromCellID: cellID) else {
            quizTestModule.finishTest(event: .forceStop)
            return
        }
        
        answer = fetchedAnswer
        
        self.pageViewController?.enableScroll()
        
        if self.testVCFactoryModule.nextQuestion == nil {
            quizTestModule.addAnswer(fetchedAnswer)
            
            quizTestModule.finishTest(event: .lastAnswer)
        }
        
    }
}


