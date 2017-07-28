//
//  HistoryScreenViewModelStorage.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class HistoryScreenViewModelStorage {
    private(set) var quizTestHistories = [QuizTestHistory]()
    
    func saveHistories(_ histories: [QuizTestHistory]) {
        quizTestHistories = histories
    }
    
    func history(byIndex index: UInt) -> QuizTestHistory? {
        if index > (quizTestHistories.count - 1) {
            return nil
        } else {
            return quizTestHistories[Int(index)]
        }
    }
}
