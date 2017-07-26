//
//  WatchSessionDictionaryKeys.swift
//  IOSQuiz
//
//  Created by galushka on 7/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum WatchSessionDataRequestKey: String {
    case get = "get"
    case post = "post"
}

enum WatchSessionDataKey: String {
    case token = "token"
    case categories = "categories"
    case questions = "questions"
    case histories = "histories"
}

enum QuestionRequestKey: String {
    case categoryID = "categoryID"
    case offset = "offset"
    case pageSize = "pageSize"
}

struct QuestionRequestParams {
    let categoryID: String
    let offset: Int
    let pageSize: Int
}
