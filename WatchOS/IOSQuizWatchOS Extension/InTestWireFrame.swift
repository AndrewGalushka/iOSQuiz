//
//  InTestWireFrame.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class InTestWireFrame {
    
    func presenterForChallengeMode(category: QuizTestCategory) -> WCInTestPresenter {
        return presenterForPassingTestKind(testMode: .challengeTest, category: category)
    }
    
    func presenterForNormalMode(category: QuizTestCategory) -> WCInTestPresenter {
        return presenterForPassingTestKind(testMode: .normalTest, category: category)
    }
    
    private func presenterForPassingTestKind(testMode: WCInTestPresentorMode, category: QuizTestCategory) -> WCInTestPresenter {
        let wcSessionManager = WatchSessionManager.shared
        let sessionRequestCollector = WatchSessionRequestCollector()
        let wcSessionReciveReplyModule = WatchSessionReceiveReplyModule(sessionManager: wcSessionManager,
                                                                        sessionRequestCollector: sessionRequestCollector)
        
        let interactor = WCInTestInteractor(wcSessionDataManager: wcSessionReciveReplyModule, category: category)
        let presenter = WCInTestPresenter(testMode: testMode, interactor: interactor)
        interactor.presentor = presenter
        interactor.setDataCache(InTestDataCache())
        
        return presenter
    }
    
    
}
