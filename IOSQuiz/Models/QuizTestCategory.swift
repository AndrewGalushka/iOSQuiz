//
//  QuizTestCategory.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

struct QuizTestCategory: Codable {
    let categoryName: String
    let categoryID: String
    
    init(categoryName: String, categoryID: String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
    }
    
    init() {
        self.categoryID = "Empty ID"
        self.categoryName = "Empty Name"
    }
}
