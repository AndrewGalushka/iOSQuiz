//
//  WatchSessionRequestCollectorType.swift
//  IOSQuiz
//
//  Created by galushka on 7/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WatchSessionRequestCollectorType {
    func requestQuestion(categoryID: String, offset: Int, pageSize: Int) -> [String: Any]
    func requestCategories() -> [String: Any]
    func requestHistories() -> [String: Any]
    func requestPostHistory(historyPostData: QuizPostHistoryModel) -> [String : Any]?
}
