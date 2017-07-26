//
//  QuizHistoryModel.swift
//  IOSQuiz
//
//  Created by galushka on 6/21/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizHistoryModule {
    
    private let serverManager = QuizServerManager()
    private let dataBase = QuizCoreDataBase()
    
    var histories: [QuizTestHistory] = []
    
    init(obtainedHistory: @escaping (_ history: [QuizHistoryTableViewCellSettings]) -> Void) {

        serverManager.history { [weak self] (response, histories) in
            guard let strongSelf = self else {return}
            
            if response == .successful {
                guard let fetchedHistories = histories else {return}
                strongSelf.histories = fetchedHistories
            } else {
                strongSelf.histories = strongSelf.dataBase.getHistories()
            }
            
            strongSelf.histories = strongSelf.histories.sorted { (prevHistory, curentHistory) -> Bool in
                return prevHistory.date > curentHistory.date
            }
        
            obtainedHistory(strongSelf.convertHistoriesToQuizPickerTableViewCellsSettings())
            return
        }
    }
    
    func convertHistoriesToQuizPickerTableViewCellsSettings() -> [QuizHistoryTableViewCellSettings] {
        let cellsSettings = histories.map { (history) -> QuizHistoryTableViewCellSettings in
            
            let date = convert(timeIntervalSince1970ToDate: TimeInterval(history.date))
            
            let dateString = convert(dateToQuizHistoryDateString: date)
            let amPmFormatString = convert(dateToAmPmFormatString: date)
            
            return QuizHistoryTableViewCellSettings(testName: history.categoryName, date: dateString, amPmFormat: amPmFormatString)
        }
        
        return cellsSettings
    }
    
}
