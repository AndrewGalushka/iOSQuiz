//
//  QuizHistoryDataSource.swift
//  IOSQuiz
//
//  Created by galushka on 6/20/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizHistoryTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    unowned let tableView: UITableView
    
    let dataSource: [QuizHistoryTableViewCellSettings]
    weak var quizHistoryTableViewDataSourceDelegate: QuizHistoryTableViewDataSourceDelegate?
    
    init(tableView: UITableView, dataSource: [QuizHistoryTableViewCellSettings]) {
        self.tableView = tableView
        self.dataSource = dataSource
        
        super.init()
        
        setUpTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: QuizHistoryTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
        cell.configure(settings: dataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func setUpTableView() {
        tableView.register(QuizHistoryTableViewCell.nib, forCellReuseIdentifier: QuizHistoryTableViewCell.ID)
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quizHistoryTableViewDataSourceDelegate?.tableView(didSelectRowAt: indexPath)
    }
}
