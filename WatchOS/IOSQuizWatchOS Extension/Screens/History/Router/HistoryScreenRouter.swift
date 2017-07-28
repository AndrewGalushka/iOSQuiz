//
//  HistoryScreenRouter.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

class HistoryScreenRouter: WKRouter {
    unowned var viewModel: HistoryScreenViewModel
    private var sharedPresenter: WCInTestHistoryPresenter?
    
    init(viewModel: HistoryScreenViewModel) {
        self.viewModel = viewModel
    }
    
    func route(to routeID: String, from context: WKInterfaceController, parameters: Any?) {
        guard let route = HistoryIntefaceController.Route(rawValue: routeID) else {
            return
        }
        
        switch route {
        case .inTestHistory:
            routeToInTestHistory(from: context, parameters: parameters)
        }
    }
    
    private func routeToInTestHistory(from context: WKInterfaceController, parameters: Any?) {
        guard let history = parameters as? QuizTestHistory else {
            return
        }
        
        let inTestHistoryWireFrame = InTestHistoryWireFrame()
        let presenter = inTestHistoryWireFrame.presenterForHistoryMode(quizTestHistory: history)
        
        sharedPresenter = presenter
        
        var contexts = [[String: Any]]()
        var controllersNames = [String]()
        let screenCount = history.results.count
        
        for index in 0..<screenCount {
            let contextDictionary = ["id": UInt(index),
                                     "presenter": presenter] as [String : Any]
            contexts.append(contextDictionary)
            controllersNames.append(InTestInterfaceController.ID)
        }
        
        context.presentController(withNames: controllersNames, contexts: contexts)
    }
}
