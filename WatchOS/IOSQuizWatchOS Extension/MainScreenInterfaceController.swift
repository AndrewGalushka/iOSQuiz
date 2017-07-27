//
//  322WK.swift
//  IOSQuiz
//
//  Created by galushka on 7/3/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit
import WatchConnectivity


class MainScreenInterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    var viewModel: MainScreenViewModel!
    var mainScreenRouter: WKRouter!
    
    let failureRequestClosureHandler: (WatchSessionDataFailure) -> Void = { (failureType) in
        print(failureType)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        setUpViewModel()
        setUpRouter()
    }
    
    override func willActivate() {
        super.willActivate()
        viewModel.categories(success: {  (categories) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.setUpTable(from: categories)
            }
        })
    }
    
    @IBAction func challengeButtonPressed() {
        if self.viewModel.isProcessesTapOnCategoriesRow { return }
        
        viewModel.categories(success: { [weak self] (categories) in
            guard let strongSelf = self else { return }
            let randCategoryIndex = Int(arc4random() % UInt32(categories.count))
            let randCategory = categories[randCategoryIndex]
            
            strongSelf.mainScreenRouter.route(to: Route.challengeTest.rawValue, from: strongSelf, parameters: randCategory)
        })
    }
    
    @IBAction func historyButtonPressed() {
        mainScreenRouter.route(to: Route.history.rawValue, from: self, parameters: nil)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        if self.viewModel.isProcessesTapOnCategoriesRow { return }
        
        if rowIndex <= (viewModel.dataStorage.categories.count - 1) {
            let category = viewModel.dataStorage.categories[rowIndex]
            mainScreenRouter.route(to: Route.normalTest.rawValue, from: self, parameters: category)
        }
    }
}

extension MainScreenInterfaceController {
    enum Route: String {
        case history
        case normalTest
        case challengeTest
    }
}

extension MainScreenInterfaceController {
    func setUpViewModel() {
        let watchSessionManager = WatchSessionManager.shared
        let watchSessionRequestCollector = WatchSessionRequestCollector()
        let wcSessionRecieveReplyModule = WatchSessionReceiveReplyModule(sessionManager: watchSessionManager,
                                                                     sessionRequestCollector: watchSessionRequestCollector)
        
        viewModel = MainScreenViewModel(sessionReceiveReplyModule: wcSessionRecieveReplyModule)
        
        viewModel.failureRequestClosureHandler = self.failureRequestClosureHandler
    }
    
    func setUpRouter() {
        mainScreenRouter = MainScreenRouter(viewModel: viewModel)
    }
}

extension MainScreenInterfaceController {
    func setUpTable(from categories: [QuizTestCategory]) {
        table.setNumberOfRows(categories.count, withRowType: "categoriesRowController")
        
        for (index, category) in categories.enumerated() {
            guard let row = table.rowController(at: index) as? CategoriesRowController else { continue }
            
            let rowSetting = CategoryRowControllerSetting(categoryName: category.categoryName, categoryID: category.categoryID)
            row.configure(setting: rowSetting)
        }
    }
}

