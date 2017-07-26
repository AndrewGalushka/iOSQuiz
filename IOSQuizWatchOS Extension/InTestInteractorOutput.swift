//
//  InTestInteractorOutput.swift
//  IOSQuiz
//
//  Created by galushka on 7/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WCInTestInteractorOutput: class {
    func receiveQuestion(_ question: QuizTestQuestion)
}
