//
//  QuizHistoryResultModule.swift
//  IOSQuiz
//
//  Created by galushka on 6/23/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation


class QuizHistoryResultModule {

    let history: QuizTestHistory
    
    init(testHistory: QuizTestHistory) {
        self.history = testHistory
    }
    
    var rightAnswersPercent: Int {
        
        let cellTypes = collectionViewCellsSettings.map{$0.cellType}
        
        let answersCount = cellTypes.count
        let rightAnswersCount = cellTypes.reduce(0) { (result, cellType) -> Int in
            
            if cellType == .correctAnswer {
                return result + 1
            } else {
                return result
            }
        }
        
        return Int(Float(rightAnswersCount) / (Float(answersCount)) * 100)
    }
    
    var collectionViewCellsSettings: [QuizHistoryCollectionViewCellSettings] {
        var cellsSettings = [QuizHistoryCollectionViewCellSettings]()
        
        for (index, result) in self.history.results.enumerated() {
            let numberID = index + 1
            var cellType: QuizHistoryAnswerMark
            
            if result.rightAnswer == result.userAnswer {
                cellType = .correctAnswer
            } else {
                cellType = .wrongAnswer
            }
            
            let cellSettings = QuizHistoryCollectionViewCellSettings(numberID: numberID, cellType: cellType)
            
            cellsSettings.append(cellSettings)
        }
        
        return cellsSettings
    }
}
