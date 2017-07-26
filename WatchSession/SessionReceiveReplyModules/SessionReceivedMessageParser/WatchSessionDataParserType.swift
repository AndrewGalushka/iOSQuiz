//
//  WatchSessionDataParserType.swift
//  IOSQuiz
//
//  Created by galushka on 7/5/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WatchSessionDataParserType {
    func requestType(from message: [String: Any]) -> WatchSessionDataRequestKey?
    func dataType(from message: [String: Any]) -> WatchSessionDataKey?
    func questionsRequestParams(from message: [String: Any]) -> QuestionRequestParams?
    func historiesPostModel(from message: [String: Any]) -> [QuizPostHistoryModel]
}
