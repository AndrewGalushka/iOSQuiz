//
//  QuizPickerTableViewDataSource.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

enum QuizPickerTableViewDataSourceMode {
    case categories
    case test
    case history
}

class QuizPickerTableViewDataSource: NSObject, UITableViewDataSource, QuizPickerTableViewCellDelegate {
    
    unowned let tableView: UITableView
    weak var quizPickerTableViewDelegate: QuizPickerTableViewCellDelegate?
    var quizPickerTableViewCellUnmarkDelegates = Set<QuizPickerTableViewCell>()
    
    let dataSource: [QuizPickerTableViewCellSettings]
    let cellType: QuizPickerTableViewCell.Type
    let mode: QuizPickerTableViewDataSourceMode
    
    init(tableView: UITableView, mode: QuizPickerTableViewDataSourceMode, dataSource: [QuizPickerTableViewCellSettings]) {
        self.tableView = tableView
        self.dataSource = dataSource
        
        self.mode = mode
        
        switch mode {
        case .categories:
            cellType = QuizPickerTableViewCell.self
        case .test, .history:
            cellType = QuizPickerTestTableViewCell.self
        }
        
        super.init()
        
        setUpTableView()
    }
    
    func makeCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> QuizPickerTableViewCell {
        switch mode {
        case .categories:
            let cell: QuizPickerTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
            
            return cell
        case .test, .history:
            let cell: QuizPickerTestTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(fromTableView: tableView, indexPath: indexPath)
    
        setUpCell(cell, settings: dataSource[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func cellDidClicked(cellID id: String) {
        
        for cell in quizPickerTableViewCellUnmarkDelegates {
            cell.unmarkLabel()
        }
        
        quizPickerTableViewDelegate?.cellDidClicked(cellID: id)
    }

    func setUpCell(_ cell: QuizPickerTableViewCell, settings: QuizPickerTableViewCellSettings) {
        
        switch mode {
        case .history:
            break
        default:
            cell.delegate = self
            self.quizPickerTableViewCellUnmarkDelegates.insert(cell)
        }
        
        cell.configure(settings: settings)
    }
    
    func setUpTableView() {
        tableView.register(cellType.nib, forCellReuseIdentifier: cellType.ID)
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
}
