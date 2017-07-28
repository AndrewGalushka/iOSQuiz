//
//  MainScreenDataStorage.swift
//  IOSQuiz
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class MainScreenDataStorage {
    private(set) var categories = [QuizTestCategory]()
    
    func saveCategories(_ categories: [QuizTestCategory]) {
        self.categories = categories
    }
}
