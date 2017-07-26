//
//  InTestHistoryPresentor.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/14/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol WCInTestHistoryPresenterInput {
    weak var view: InTestHistoryView? { get set }
    
    func didAppear(view: InTestHistoryView)
    func willDisappear()
}

class WCInTestHistoryPresenter {
    weak var view: InTestHistoryView?
    private let interactor: InTestHistoryInteractorType
    private let convertor = InTestHistoryInteractorDataConvertor()
    
    init(interactor: InTestHistoryInteractorType) {
        self.interactor = interactor
    }
}

extension WCInTestHistoryPresenter: WCInTestHistoryPresenterInput {
    
    func didAppear(view: InTestHistoryView) {
        self.view = view
        
        guard let historyResult = interactor.historyResult(byIndex: view.questionNumber) else { return }
        let inTestInterfacecontrollerSetting = convertor.inTestInterfaceControllerSetting(from: historyResult)
        
        view.showHistoryResult(setting: inTestInterfacecontrollerSetting)
    }
    
    func willDisappear() {
        view = nil
    }
}
