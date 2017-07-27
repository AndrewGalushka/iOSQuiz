//
//  QuizPickerTableViewCellType.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

protocol QuizPickerTableViewCellType {
    weak var delegate: QuizPickerTableViewCellDelegate? { get set }
    var id: String? { get set }
    func configure(settings: QuizPickerTableViewCellSettings)
    func cellDidClicked()
}
