//
//  QuizInTestModuleDelegate.swift
//  IOSQuiz
//
//  Created by galushka on 6/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

enum QuizInTestModuleStopEventType {
    case timeLeft
    case lastAnswer
    case forceStop
    case wrongAnswer
}

protocol QuizInTestModuleDelegate: class {
    func timerFire(secondsLeft seconds: Int)
    func stopTest(stopedEvent: QuizInTestModuleStopEventType)
}
