//
//  PostDetailViewProtocol.swift
//  IOSQuiz
//
//  Created by galushka on 7/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol InTestView: class {
    var questionNumber: UInt { get }
    
    func showQuestion(setting: InTestInterfaceControllerSetting)
    func dataProvidingFailed(failureType: WatchSessionDataFailure)
    func finishTest(withEvent: WCInTestPresenterFinishTestEvent)
    
    func changeTimerTime(_ time: String)
}

