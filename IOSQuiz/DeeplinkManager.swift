//
//  DeeplinkManager.swift
//  IOSQuiz
//
//  Created by galushka on 6/30/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

enum ShortcutKey: String {
    case challenge = "com.iosquiz.shortcut.challenge"
    case randomQuestion = "com.iosquiz.shortcut.randomquestion"
    case feedBack = "com.iosquiz.shortcut.feedback"
}

enum DeeplinkType {
    enum SingleQuestionType {
        case define(questionID: String)
        case random
    }
    
    case singleQuestion(type: SingleQuestionType)
    case challenge
    case feedback
}


class DeeplinkManager {
    
    func deepLinkType(from url: URL) -> DeeplinkType? {
        
        let question = "question"
        let challenge = "challenge"
        let feedback = "feedback"
        
        guard let host = url.host else {
            return nil
        }
        
        switch host {
        case question:
            let path = url.lastPathComponent
            
            if path == "" {
                return nil
            }
            
            if path == "random" {
                return DeeplinkType.singleQuestion(type: DeeplinkType.SingleQuestionType.random)
            } else {
                return DeeplinkType.singleQuestion(type: DeeplinkType.SingleQuestionType.define(questionID: path))
            }
        case challenge:
            return .challenge
        case feedback:
            return .feedback
        default:
            return nil
        }
    }
    
    func deepLinkType(from shortcutItem: UIApplicationShortcutItem) -> DeeplinkType? {
        guard let shortcutKey = ShortcutKey.init(rawValue: shortcutItem.type) else {
            return nil
        }
        
        switch shortcutKey {
        case .challenge:
            return .challenge
        case .randomQuestion:
            return .singleQuestion(type: .random)
        case .feedBack:
            return .feedback
        }
    }
    
    func processDeepLink(_ deepLink: DeeplinkType, window: UIWindow) {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            print("ERROR: can't convert rootViewController as UINavigationController -> QuizAppDelegateModule \(#line)")
            return
        }
        
        switch deepLink {
        case .challenge:
            guard let mainScreenController = navigationController.topViewController as? MainScreenViewController else {
                return
            }
            
            mainScreenController.challengeButtonPressed(self)
            
        case .singleQuestion(let singleQuestionType):
            if navigationController.topViewController is MainScreenViewController {
                let testViewController = QuizTestQuestionViewController(from: quizTestQuestionViewControllerSettings(from: singleQuestionType))
                navigationController.pushViewController(testViewController, animated: true)
            }
        case .feedback:
            if navigationController.topViewController is MainScreenViewController {
                let feedbackViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: QuizFeedbackViewController.storyboardID)
                navigationController.pushViewController(feedbackViewController, animated: true)
            }
        }
        
    }
    
    func quizTestQuestionViewControllerSettings(from singleQuestionType: DeeplinkType.SingleQuestionType) -> QuizTestQuestionViewControllerSettings {
        switch singleQuestionType {
        case .define(let questionID):
            return QuizTestQuestionViewControllerSettings.singleQuestion(type: SingleQuestionType.questionID(questionID: questionID))
        case .random:
            return QuizTestQuestionViewControllerSettings.singleQuestion(type: SingleQuestionType.randomQuestion)
        }
    }
}

