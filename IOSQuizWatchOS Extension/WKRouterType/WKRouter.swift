//
//  RouterType.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

protocol WKRouter {
    func route(
        to routeID: String,
        from context: WKInterfaceController,
        parameters: Any?
    )
}
