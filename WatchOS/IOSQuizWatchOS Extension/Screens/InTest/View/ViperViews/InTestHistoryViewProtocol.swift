//
//  InTestHistoryViewProtocol.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol InTestHistoryView: class {
    var questionNumber: UInt { get }
    func showHistoryResult(setting: InTestInterfaceControllerSetting)
}
