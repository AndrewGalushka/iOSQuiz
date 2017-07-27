//
//  InTestDataCacheType.swift
//  IOSQuiz
//
//  Created by galushka on 7/13/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol InTestDataCacheRetrieveType {
    func question(byIndex index: UInt) -> QuizTestQuestion?
}

protocol InTestDataCacheAddType {
    func addQuestion(_ question: QuizTestQuestion)
}

typealias InTestDataCacheType = InTestDataCacheRetrieveType & InTestDataCacheAddType
