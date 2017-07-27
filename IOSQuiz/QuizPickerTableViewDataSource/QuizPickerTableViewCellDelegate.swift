//
//  QuizPickerTableViewCellDelegate.swift
//  IOSQuiz
//
//  Created by galushka on 6/21/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol QuizPickerTableViewCellDelegate: class {
    func cellDidClicked(cellID: String)
}
