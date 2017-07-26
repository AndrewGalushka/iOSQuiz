//
//  QuizTestViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

extension QuizTestViewController {
    enum SegueIdentifier: String {
        case testPageViewController = "TestPageViewController"
    }
}

protocol QuizTestFinishTestDelegate {
     func finishTest(event: QuizInTestModuleStopEventType)
}

enum QuizTestMode: Equatable {
    case normal
    case challenge
    case history(historyResults: [QuizTestHistoryResult], currentQuestion: Int)
    
    static func ==(lhs: QuizTestMode, rhs: QuizTestMode) -> Bool {
        switch (lhs, rhs) {
        case (.normal, .normal):
            return true
        case (.challenge, .challenge):
            return true
        case (.history(_, _), .history(_, _)):
            return true
        default:
            return false
        }
    }
}

class QuizTestViewController: UIViewController, QuizInTestModuleDelegate, SegueHandler {
    
    @IBOutlet weak var stopBarButtonItem: UIBarButtonItem!

    var timerLabel: UILabel?
    var timer: Timer?
    var finishTestDelegate: QuizTestFinishTestDelegate?
    var testCategory: QuizTestCategory?
    
    var quizInTestModule: QuizInTestModule?
    
    let quizAlerts = QuizAlerts()
    
    var testMode: QuizTestMode = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch testMode {
        case .normal, .challenge:
            createAndSetUpTimerLabel()
        case .history:
            self.navigationItem.setRightBarButton(nil, animated: false)
        }
        
        setUpNavigationItemTitle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .testPageViewController:
            
            if let unwrappedPageViewController = segue.destination as? QuizTestPageViewController {
                setUpQuizTestPageViewController(unwrappedPageViewController)
            }
        }
    
    }
    
    private func createAndSetUpTimerLabel() {
        self.timerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: self.navigationController?.navigationBar.frame.height ?? 0.0))
        self.timerLabel?.backgroundColor = .clear
        self.timerLabel?.textColor = .white
        let barButtonItem = UIBarButtonItem(customView: self.timerLabel ?? UIView())
        
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func timerFire(secondsLeft seconds: Int) {
        
        let (_, minutes, seconds) = convert(secondsToHoursMinutesSeconds: seconds)
        
        let minutesString = minutes >= 10 ? String(minutes) : "0\(minutes)"
        let secondsString = seconds >= 10 ? String(seconds) : "0\(seconds)"
        
        let timeString = minutesString + ":" + secondsString
        
        timerLabel?.text = timeString
    }
    
    func stopTest(stopedEvent: QuizInTestModuleStopEventType) {
        
        switch stopedEvent {
        case .forceStop:
            self.dismiss(animated: true, completion: nil)
        case .lastAnswer:
            quizAlerts.presentTestIsFishedAlert(on: self, alertActionComplition: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        case .timeLeft:
            quizAlerts.presentTimeLeftAlert(on: self, alertActionComplition: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            break
        case .wrongAnswer:
            quizAlerts.presentWrongAnswerAlert(on: self, alertActionComplition: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func setUpNavigationItemTitle() {
        if testMode ==  .normal {
            self.navigationItem.title = testCategory?.categoryName
        } else if testMode == .challenge {
            self.navigationItem.title = "Challenge"
        }
    }
    
    @IBAction func stopTestButtonAction(_ sender: Any) {
        presentStopTestAlert()
    }
    
    func presentStopTestAlert() {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let stopAction = UIAlertAction(title: "Stop", style: .default) { (action) in
            self.finishTestDelegate?.finishTest(event: .forceStop)
        }
        
        let alertController = UIAlertController(title: "Stop test", message: "Stop this test?", preferredStyle: .alert)
        alertController.addAction(cancelAction)
        alertController.addAction(stopAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpQuizTestPageViewController(_ quizPageViewController: QuizTestPageViewController) {
        
        if testMode == .normal || testMode == .challenge {
            guard let category = testCategory else {
                return
            }
            
            quizPageViewController.testCategory = category
            self.finishTestDelegate = quizPageViewController
        }
        
        switch testMode {
        case .normal:
            quizPageViewController.mode = .normal
            quizPageViewController.topLevelControllerModuleDelegate = self
        case .challenge:
            quizPageViewController.mode = .challenge
            quizPageViewController.topLevelControllerModuleDelegate = self
        case .history(let historyResults, let currentQuestion):
            quizPageViewController.mode = .history(historyResults: historyResults, currentQuestion: currentQuestion)
        }
    }
}
