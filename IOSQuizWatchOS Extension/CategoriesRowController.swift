//
//  CategoriesRowController.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

struct CategoryRowControllerSetting {
    let categoryName: String
    let categoryID: String
}

class CategoriesRowController: NSObject {
    var categoryID: String?
    @IBOutlet var testNameLabel: WKInterfaceLabel!
    
    func configure(setting: CategoryRowControllerSetting) {
        testNameLabel.setText(setting.categoryName)
        categoryID = setting.categoryID
    }
}
