//
//  QuizHistoryTableViewDataSourceDelegate.swift
//  IOSQuiz
//
//  Created by galushka on 6/21/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

protocol QuizHistoryTableViewDataSourceDelegate: class {
    func tableView(didSelectRowAt indexPath: IndexPath)
}
