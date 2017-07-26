//
//  QuizHistoryViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/20/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

let quizHistoryResultStoryboardSegueID = "QuizHistoryResultStoryboardSegueID"

class QuizHistoryViewController: UIViewController, UITableViewDelegate, SegueHandler {

    @IBOutlet weak var historyTableView: UITableView!
    var historyTableViewDataSource: QuizHistoryTableViewDataSource?
    
    var quizHistoryModule: QuizHistoryModule?
    
    let loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading()
        
        quizHistoryModule = QuizHistoryModule(obtainedHistory: { (cellSettings) in
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                strongSelf.historyTableViewDataSource = QuizHistoryTableViewDataSource(tableView: strongSelf.historyTableView,
                                                                                       dataSource: cellSettings)
                strongSelf.historyTableView.dataSource = strongSelf.historyTableViewDataSource
                strongSelf.historyTableView.delegate = strongSelf
                strongSelf.historyTableView.reloadData()
                
                strongSelf.endLoading()
            }
        })
    }
    
    func addRefreshControll(to tableView: UITableView) {
        let refreshControll = UIRefreshControl()
        refreshControll.backgroundColor = .cyan
        
    }
    
    func refreshAction() {
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let history = quizHistoryModule?.histories[indexPath.row] else {return}
        
        self.performSegue(withIdentifier: SegueIdentifier.quizHistoryResultStoryboardSegueID.rawValue, sender: history)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isToolbarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
            
        case .quizHistoryResultStoryboardSegueID:
            guard let history = sender as? QuizTestHistory else {return}
            guard let historyResultViewController = segue.destination as? QuizHistoryResultViewController else {
                return
            }
            
            historyResultViewController.testHistory = history
        }
    }
    
    func startLoading() {
        let indicatorRect = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, width: 0, height: 0)

        self.loadingIndicator.frame = indicatorRect
        //self.loadingIndicator.color = .blue
        
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
    }
    
    func endLoading() {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.removeFromSuperview()
    }
    
    enum SegueIdentifier: String {
        case quizHistoryResultStoryboardSegueID = "QuizHistoryResultStoryboardSegueID"
    }
}
