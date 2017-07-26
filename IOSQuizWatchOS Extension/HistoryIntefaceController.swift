//
//  HistoryIntefaceController.swift
//  IOSQuiz
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import WatchKit

class HistoryIntefaceController: WKInterfaceController {
    @IBOutlet var historyInterfaceTable: WKInterfaceTable!
    var historyViewModel: HistoryScreenViewModel!
    var router: HistoryScreenRouter!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setUpHistoryScreenViewModel()
    }
    
    override func willActivate() {
        super.willActivate()
        
        historyViewModel.historyTableSettings(success: {  (tableViewRowSettings) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.setUpRows(with: tableViewRowSettings)
            }
        }, failure: { (failureType) in
            print(failureType)
        })
    }
    
    func setUpHistoryScreenViewModel() {
        let wcSessionReceiveReplyModule = WatchSessionReceiveReplyModule(sessionManager: WatchSessionManager.shared,
                                                                         sessionRequestCollector: WatchSessionRequestCollector())
        historyViewModel = HistoryScreenViewModel(sessionReceiveReplyModule: wcSessionReceiveReplyModule)
        router = HistoryScreenRouter(viewModel: historyViewModel)
    }
    
    func setUpRows(with settings: [HistoryRowControllerSettings]) {
        historyInterfaceTable.setNumberOfRows(settings.count, withRowType: "HistoryRowController")
        
        for (index, setting) in settings.enumerated() {
            guard let historyRowController = historyInterfaceTable.rowController(at: index) as? HistoryRowController else { return }
    
            historyRowController.configure(settings: setting)
        }
    }
}

extension HistoryIntefaceController {
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let history = historyViewModel.history(byIndex: UInt(rowIndex)) else {
            return
        }
        
        router.route(to: Route.inTestHistory.rawValue, from: self, parameters: history)
    }
}

extension HistoryIntefaceController {
    enum Route: String {
        case inTestHistory
    }
}


