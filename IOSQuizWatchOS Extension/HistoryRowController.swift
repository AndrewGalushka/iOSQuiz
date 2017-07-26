//
//  HistoryRowController.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

struct HistoryRowControllerSettings {
    let testName: String
    let testDate: String
}

class HistoryRowController: NSObject {
    @IBOutlet var testNameLabel: WKInterfaceLabel!
    @IBOutlet var testDateLabel: WKInterfaceLabel!
    
    func configure(settings: HistoryRowControllerSettings) {
        testNameLabel.setText(settings.testName)
        testDateLabel.setText(settings.testDate)
    }
}
