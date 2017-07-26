//
//  QuizTestPageViewControllerHistoryDataSource.swift
//  IOSQuiz
//
//  Created by galushka on 6/22/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizTestPageViewControllerHistoryDataSource: NSObject {
    
    weak var pageViewController: QuizTestPageViewController?
    fileprivate let historyViewControllerFactoryModule: QuizPageViewControllerHistoryVCFactoryModule
    
    var transitionFrom = UIViewController()
    
    init(pageViewController: QuizTestPageViewController, historyResults: [QuizTestHistoryResult], beginState: Int) {
        
        self.pageViewController = pageViewController
        historyViewControllerFactoryModule = QuizPageViewControllerHistoryVCFactoryModule(historyResults: historyResults, beginState: beginState)
        
        super.init()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let fetchedCurrentVC = historyViewControllerFactoryModule.currentViewController {
            pageViewController.setViewControllers([fetchedCurrentVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
}

extension QuizTestPageViewControllerHistoryDataSource: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return historyViewControllerFactoryModule.prevViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return historyViewControllerFactoryModule.nextViewController
    }
}

extension QuizTestPageViewControllerHistoryDataSource: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let transitionFrom = pageViewController.viewControllers?.last {
            self.transitionFrom = transitionFrom
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard transitionFrom != pageViewController.viewControllers?.last else {
            return
        }
        
        guard
            let previousViewController = transitionFrom as? QuizTestQuestionViewController,
            let currentViewController = pageViewController.viewControllers?.last as? QuizTestQuestionViewController
            else {
                return
        }
        
        guard previousViewController != currentViewController else { return }
        
        guard
            let previousVCIndex = previousViewController.index,
            let currentVCIndex = currentViewController.index
            else {
                return
        }
        
        if previousVCIndex > currentVCIndex {
            historyViewControllerFactoryModule.stepBack()
        } else {
            historyViewControllerFactoryModule.stepForward()
        }
    }
}
