//
//  QuizInTestPageViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizTestPageViewController: UIPageViewController, UIPageViewControllerDelegate, QuizInTestModuleDelegate, QuizTestFinishTestDelegate {
    
    var quizTestModule: QuizInTestModule?
    var testCategory: QuizTestCategory?
    
    var mode = QuizTestMode.normal

    weak var topLevelControllerModuleDelegate: QuizInTestModuleDelegate?
    
    var scrollView: UIScrollView?
    
    let quizAlerts = QuizAlerts()
    
    var transitionFrom = UIViewController()
    var quizPageViewControllerTestModule: QuizPageViewControllerTestVCFactoryModule?
    
    var pageViewControllerTestDataSource: QuizTestPageViewControllerInTestDataSource?
    var pageViewControllerHistoryDataSource: QuizTestPageViewControllerHistoryDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpScrollViewProperty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setUpTest()
        self.navigationItem.title = testCategory?.categoryName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if mode == .challenge || mode == .normal {
            self.quizTestModule?.startTest()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpScrollViewProperty() {
        
        if let pageView =  self.view {
            for scroll in pageView.subviews  {
                if scroll is UIScrollView {
                    scrollView = (scroll as? UIScrollView)
                }
            }
        }
    }
    
    func disableScroll() {
        self.scrollView?.isScrollEnabled = false
    }
    
    func enableScroll() {
        self.scrollView?.isScrollEnabled = true
    }
    
    func setUpTestModule() {
        guard let category = testCategory else {
            return
        }
        
        if mode == .normal {
            self.quizTestModule = QuizInTestModule(testCategory: category, mode: .test)
        } else if mode == .challenge {
            self.quizTestModule = QuizInTestModule(testCategory: category, mode: .challenge)
        }
        
        
    }
    
    //MARK: QuizInTestModuleDelegate
    func timerFire(secondsLeft seconds: Int) {
        topLevelControllerModuleDelegate?.timerFire(secondsLeft: seconds)
    }
    
    // MARK: QuizInTestModuleDelegate
    func stopTest(stopedEvent: QuizInTestModuleStopEventType) {
        disableScroll()
        topLevelControllerModuleDelegate?.stopTest(stopedEvent: stopedEvent)
    }
    
    func presentConnetionTroubleAlert(fromTestModuleResponseResult responseResult: QuizInTestModuleResult, actionComplition: QuizAlerts.actionComplition?) {
        
        if responseResult == .notConnectedToInternet {
            quizAlerts.presentNotConnectedToInternet(on: self, alertActionComplition: actionComplition)
        } else if responseResult == .cantConnectToServer {
            quizAlerts.presentCantConnectToServer(on: self, alertActionComplition: actionComplition)
        }
    }
    
    func setUpTest() {
        switch mode {
        case .normal:
            setUpTestModule()
            
            if let fetchedQuizTestModule = quizTestModule {
                pageViewControllerTestDataSource = QuizTestPageViewControllerInTestDataSource(pageViewController: self, quizInTestModule: fetchedQuizTestModule)
            }
            
        case .challenge:
            setUpTestModule()
            
            if let fetchedQuizTestModule = quizTestModule {
                pageViewControllerTestDataSource = QuizTestPageViewControllerInTestDataSource(pageViewController: self, quizInTestModule: fetchedQuizTestModule)
            }

        case .history(let historyResults, let beginingQestion):
            pageViewControllerHistoryDataSource = QuizTestPageViewControllerHistoryDataSource(pageViewController: self, historyResults: historyResults, beginState: beginingQestion)
        }
    }
    
    func finishTest(event: QuizInTestModuleStopEventType) {
        self.quizTestModule?.finishTest(event: event)
    }
    
}
