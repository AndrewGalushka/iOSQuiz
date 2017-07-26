//
//  InTestHistoryWireFrame.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct InTestHistoryWireFrame {
    func presenterForHistoryMode(quizTestHistory history: QuizTestHistory) -> WCInTestHistoryPresenter {
        let interactor = InTestHistoryInteractor(history: history)
        let presentor = WCInTestHistoryPresenter(interactor: interactor)
        
        return presentor
    }
}
