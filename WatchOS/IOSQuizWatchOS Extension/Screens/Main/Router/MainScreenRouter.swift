//
//  MainScreenRouter.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

enum PassingTestType {
    case normal
    case challenge
}

class MainScreenRouter: WKRouter {
    unowned var viewModel: MainScreenViewModel
    private var inTestPresentor: WCInTestPresenter? = nil
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
    }
    
    func route(to routeID: String, from context: WKInterfaceController, parameters: Any?) {
        guard let route = MainScreenInterfaceController.Route(rawValue: routeID) else {
            return
        }
        
        switch route {
        case .history:
            routeToHistoryScreen(from: context)
        case .challengeTest:
            routeToTestScreen(passingTestType: .challenge, from: context, parameters: parameters)
        case .normalTest:
            routeToTestScreen(passingTestType: .normal, from: context, parameters: parameters)
        }
    }
    
    private func routeToHistoryScreen(from context: WKInterfaceController) {
        context.presentController(withName: HistoryIntefaceController.ID, context: nil)
    }
    
    private func routeToTestScreen(passingTestType type: PassingTestType, from context: WKInterfaceController, parameters: Any?) {
        guard let category = parameters as? QuizTestCategory else { return }
        
        viewModel.isProcessesTapOnCategoriesRow = true
        
        let requestParams = QuestionRequestParams(categoryID: category.categoryID, offset: 0, pageSize: 0)
        viewModel.questions(requestParams: requestParams, success: { [weak self] (questions) in
            guard let strongSelf = self else { return }
            
            let screenCount = questions.count
            let wireFrame = InTestWireFrame()
            let presenter: WCInTestPresenter
            
            switch type {
            case .challenge:
                presenter = wireFrame.presenterForChallengeMode(category: category)
            case .normal:
                presenter = wireFrame.presenterForNormalMode(category: category)
            }
            
            presenter.questionsCount = screenCount
            strongSelf.inTestPresentor = presenter
            
            var contexts = [[String: Any]]()
            var controllersNames = [String]()
            
            for index in 0..<screenCount {
                let contextDictionary = ["id": UInt(index),
                                         "presenter": presenter] as [String : Any]
                contexts.append(contextDictionary)
                controllersNames.append(InTestInterfaceController.ID)
            }
            
            DispatchQueue.main.async {
                strongSelf.viewModel.isProcessesTapOnCategoriesRow = false
                context.presentController(withNames: controllersNames, contexts: contexts)
            }
            
        }, failure: {[weak self]  _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isProcessesTapOnCategoriesRow = false
        })
    }

}
