//
//  QuizTestQuestionViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/9/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizTestQuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    
    var quizPickerTableViewCellDelegate: QuizPickerTableViewCellDelegate?
    
    var dataSource: QuizPickerTableViewDataSource?
    let questionViewControllerSettings: QuizTestQuestionViewControllerSettings?
    
    var index: Int?

    let quizTestQuestionViewControllerModule = QuizTestQuestionViewControllerModule()
    
    lazy var quizAlerts = {
        return QuizAlerts()
    }()
    
    convenience init(from settings: QuizTestQuestionViewControllerSettings?) {
        
        self.init(nibName: QuizTestQuestionViewController.nibName(),
                  bundle: QuizTestQuestionViewController.bundle(),
                  settings: settings)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, settings: QuizTestQuestionViewControllerSettings?) {
        self.questionViewControllerSettings = settings
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        questionViewControllerSettings = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fetchedQuizTestQuestionViewControllerSettings = questionViewControllerSettings {
            setUp(from: fetchedQuizTestQuestionViewControllerSettings)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUp(from viewControllerSettings: QuizTestQuestionViewControllerSettings) {
        
        quizTestQuestionViewControllerModule.cellSettings(fromQuizTestViewControllerSettings: viewControllerSettings) { [weak self] (dataSourceCellSettings) in
            
            guard
                let cellSettings = dataSourceCellSettings,
                let strongSelf = self
                else {
                    return
            }
            DispatchQueue.main.async {
                var tableViewDataSourceMode: QuizPickerTableViewDataSourceMode
                
                switch viewControllerSettings {
                case .history(let historyResult):
                    tableViewDataSourceMode = .history
                    strongSelf.questionLabel.text = historyResult.question
                    
                case .test(let question):
                    tableViewDataSourceMode = .test
                    
                    strongSelf.dataSource?.quizPickerTableViewDelegate = self
                    strongSelf.questionLabel.text = question.questionText
                    
                case .singleQuestion(_):
                    tableViewDataSourceMode = .test
                    strongSelf.questionLabel.text = strongSelf.quizTestQuestionViewControllerModule.questionText
                    break
                }
                
                
                strongSelf.dataSource = QuizPickerTableViewDataSource(tableView: strongSelf.answersTableView,
                                                                      mode: tableViewDataSourceMode,
                                                                      dataSource: cellSettings)
                
                if case QuizTestQuestionViewControllerSettings.test(_) = viewControllerSettings {
                    strongSelf.dataSource?.quizPickerTableViewDelegate = self
                }
                
                if case QuizTestQuestionViewControllerSettings.singleQuestion(_) = viewControllerSettings {
                    strongSelf.dataSource?.quizPickerTableViewDelegate = self
                }
                
                strongSelf.answersTableView.dataSource = strongSelf.dataSource
                strongSelf.answersTableView.separatorStyle = .none
                strongSelf.answersTableView.reloadData()
            }
        }
    }
}

extension QuizTestQuestionViewController: QuizPickerTableViewCellDelegate {
    
    func cellDidClicked(cellID: String) {
        
        if let viewControllerSettings = questionViewControllerSettings,
            case .singleQuestion(_) = viewControllerSettings {
            
            guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            
            let popViewControllerClosure: (_ action: UIAlertAction) -> Void = { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            
            if quizTestQuestionViewControllerModule.isAnswerRight(userAnswer: cellID) {
                quizAlerts.presentInformAlert(on: mainViewController, title: "Answer Is Right!", message: nil, alertActionComplition: popViewControllerClosure)
            } else {
                quizAlerts.presentWrongAnswerAlert(on: mainViewController, alertActionComplition: popViewControllerClosure)
            }
            
        }
        
        quizPickerTableViewCellDelegate?.cellDidClicked(cellID: cellID)
    }
}

