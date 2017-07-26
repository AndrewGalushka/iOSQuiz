//
//  HistoryScreenViewModel.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class HistoryScreenViewModel {
    private let sessionReceiveReplyModule: WatchSessionReceiveReplyModuleType
    private let storage = HistoryScreenViewModelStorage()
    
    init(sessionReceiveReplyModule: WatchSessionReceiveReplyModuleType) {
        self.sessionReceiveReplyModule = sessionReceiveReplyModule
    }
    
    func historyTableSettings(success successClosure: @escaping (_ historyRowcontrollersSettings: [HistoryRowControllerSettings]) -> Void,
                              failure failureClosure: @escaping (_ failureType: WatchSessionDataFailure) -> Void) {
        sessionReceiveReplyModule.histories { [weak self] (historiesResult) in
            
            guard let strongSelf = self else { return }
            
            switch historiesResult {
            case .Success(let histories):
                let sortedHistory = histories.sorted(by: { (history1, history2) -> Bool in
                    return history1.date > history2.date
                })
                
                print(sortedHistory)
                strongSelf.storage.saveHistories(sortedHistory)
                let rowsSettings = strongSelf.historyIntefaceTableSettings(from: sortedHistory)
                successClosure(rowsSettings)
            case .Failure(let failureType):
                failureClosure(failureType)
            }
        }
    }
    
    func history(byIndex index: UInt) -> QuizTestHistory? {
        return storage.history(byIndex: index)
    }
    
    private func historyIntefaceTableSettings(from histories: [QuizTestHistory]) -> [HistoryRowControllerSettings] {
        let historyRowControllersSettings = histories.map { (history) -> HistoryRowControllerSettings in
            let date = convert(timeIntervalSince1970ToDate: TimeInterval(history.date))
            
            let dateString = convert(dateToQuizHistoryDateString: date) + convert(dateToAmPmFormatString: date)
            let testName = history.categoryName
            
            return HistoryRowControllerSettings(testName: testName, testDate: dateString)
        }
        
        return historyRowControllersSettings
    }
}
