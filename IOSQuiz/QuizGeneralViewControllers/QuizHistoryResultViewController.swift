//
//  QuizHistoryViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/19/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

protocol QuizHistoryCollectionViewDelegate: class {
    func itemDidSelected(at indexPath: IndexPath)
}

extension QuizHistoryResultViewController: QuizHistoryCollectionViewDelegate {
    func itemDidSelected(at indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueIdentifier.inTestViewController.rawValue, sender: indexPath.row)
    }
}

extension QuizHistoryResultViewController: SegueHandler {
    enum SegueIdentifier: String {
        case inTestViewController = "quizSegueFromHistoryViewControllerToInTestViewController"
    }
}

class QuizHistoryResultViewController: UIViewController {
    let quizServerManager = QuizServerManager()
    
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var quizHistoryCollectionView: UICollectionView!
    var quizHistoryCollectionViewDataSource: QuizHistoryCollectionViewDataSource?
    
    var testHistory: QuizTestHistory? {
        set(history) {
            if let fetchedHistory = history {
                self.quizHistoryResultModule = QuizHistoryResultModule(testHistory: fetchedHistory)
            }
        }
        
        get {
            return self.quizHistoryResultModule?.history
        }
    }
    
    var quizHistoryResultModule: QuizHistoryResultModule?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if let fetchedHistoryResultModule = quizHistoryResultModule {
            
            quizHistoryCollectionViewDataSource = QuizHistoryCollectionViewDataSource(collectionView: quizHistoryCollectionView, cellsSettings: fetchedHistoryResultModule.collectionViewCellsSettings)
            
            quizHistoryCollectionView.dataSource = quizHistoryCollectionViewDataSource
            quizHistoryCollectionViewDataSource?.delegate = self
            
            percentLabelSetText(from: fetchedHistoryResultModule.rightAnswersPercent)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .inTestViewController:
            
            if  let beginingQuestion = sender as? Int,
                let testViewController = segue.destination as? QuizTestViewController,
                let historyResults = self.testHistory?.results {
                
                testViewController.testMode = .history(historyResults: historyResults, currentQuestion: beginingQuestion)
            }
            
            break
        }
    }
    
    func percentLabelSetText(from percent: Int) {
        percentLabel.text = "\(percent) %"
    }
}
