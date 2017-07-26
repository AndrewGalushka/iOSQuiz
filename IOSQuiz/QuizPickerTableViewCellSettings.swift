//
//  QuizTableViewSettings.swift
//  IOSQuiz
//
//  Created by galushka on 6/22/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum QuizPickerTableViewCellSettings {
    case test(testCellSettings: QuizPickerTableViewBaseCellSettings)
    case history(historyCellSettings: QuizPickerTableViewHistoryCellSettings)
}
