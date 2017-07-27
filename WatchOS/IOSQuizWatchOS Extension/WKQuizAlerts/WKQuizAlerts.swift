//
//  WKQuizAlerts.swift
//  IOSQuiz
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

struct WKQuizInformAlertParams {
    let title: String
    let message: String
}

enum WKQuizInformAlertType {
    case testTimeLeft
    case testWrongAnswer
    case testSuccessEnd
    
    func informAlertParams() -> WKQuizInformAlertParams {
        switch self {
        case .testSuccessEnd:
            return WKQuizInformAlertParams(title: "Test is finished", message: "View Your Result in History Screen")
        case .testTimeLeft:
            return WKQuizInformAlertParams(title: "Time Left", message: "Test Is Failed!")
        case .testWrongAnswer:
            return WKQuizInformAlertParams(title: "Wrong Answer", message: "Test Is Failed!")
        }
    }
}

struct WKQuizAlerts {
    func presentInformAlert(on controller: WKInterfaceController, title: String?, message: String?,
                            actionClosure: @escaping () -> Void) {
        let okAction = WKAlertAction(title: "OK", style: .default, handler: actionClosure)
        controller.presentAlert(withTitle: title, message: message, preferredStyle: .actionSheet, actions: [okAction])
    }
    
    func presentInformAlert(on controller: WKInterfaceController,
                            informAlertType: WKQuizInformAlertType,
                            actionClosure: @escaping () -> Void) {
        let informAlertParams = informAlertType.informAlertParams()
        presentInformAlert(on: controller, title: informAlertParams.title, message: informAlertParams.message, actionClosure: actionClosure)
    }
}
