//
//  QuizTestQuestionViewControllerModule.swift
//  IOSQuiz
//
//  Created by galushka on 6/27/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class QuizTestQuestionViewControllerModule {
    
    var question: QuizTestQuestion?
    var questionText: String {
        return question?.questionText ?? ""
    }
    
    private lazy var serverManager: QuizServerManager = {
        QuizServerManager()
    }()
    
    func cellSettings(fromQuizTestViewControllerSettings viewControllerSettings: QuizTestQuestionViewControllerSettings,
                      completionClosure: @escaping (_ quizCellSettings: [QuizPickerTableViewCellSettings]?) -> Void) {
        
        switch viewControllerSettings {
        case .test(let quizTestQuestion):
            let cellSettings = dataSourceCellSettings(fromTestQuestion: quizTestQuestion)
            completionClosure(cellSettings)
            return
        case .history(let quizTestHistoryResult):
            let cellSettings = dataSourceCellSettings(fromHistoryResult: quizTestHistoryResult)
            completionClosure(cellSettings)
        case .singleQuestion(let singleQuestionType):
            dataSourceCellSettings(from: singleQuestionType, completionClosure: { (settings) in
                completionClosure(settings)
                return
            })
        }
    }
    
    private func dataSourceCellSettings(fromTestQuestion testQuestion: QuizTestQuestion) -> [QuizPickerTableViewCellSettings] {
        let settings = testQuestion.answers.map{
            QuizPickerTableViewCellSettings.test(testCellSettings:
                QuizPickerTableViewBaseCellSettings(labelText: $0, uniqueID: $0))
        }
        
        return settings
    }
    
    private func dataSourceCellSettings(fromHistoryResult historyResult: QuizTestHistoryResult) -> [QuizPickerTableViewCellSettings] {
        let answers = historyResult.answers
        let rightAnswer = historyResult.rightAnswer
        let userAnswer = historyResult.userAnswer
        
        var dataSourceCellSettings = [QuizPickerTableViewCellSettings]()
        
        for (index, value) in answers.enumerated() {
            var answerMark: QuizHistoryAnswerMark?
            
            if index == rightAnswer && index == userAnswer {
                answerMark = .correctAnswer
            } else if index == rightAnswer {
                answerMark = .correctAnswer
            } else if index ==  userAnswer {
                answerMark = .wrongAnswer
            }
            
            let tableViewHistoryCellSettings = QuizPickerTableViewHistoryCellSettings(labelText: value, labelAnswerMark: answerMark)
            
            dataSourceCellSettings.append(QuizPickerTableViewCellSettings.history(historyCellSettings:
                tableViewHistoryCellSettings))
            
        }
        
        return dataSourceCellSettings
    }
    
    private func dataSourceCellSettings(from singleQuestionMode: SingleQuestionType, completionClosure: @escaping (_ settings: [QuizPickerTableViewCellSettings]?) -> Void ) {
        question(from: singleQuestionMode) { [weak self] (question) in
            
            guard
                let fetchedQuestion = question,
                let strongSelf = self
                else {
                    completionClosure(nil)
                    return
            }
            
            strongSelf.question = fetchedQuestion
            let settings = strongSelf.dataSourceCellSettings(fromTestQuestion: fetchedQuestion)
            completionClosure(settings)
            return
        }
    }
    
    private func question(from singleQuestionType: SingleQuestionType, compitionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        switch singleQuestionType {
        case .questionID(let questionID):
            question(fromQuestionID: questionID, compitionClosure: { (question) in
                compitionClosure(question)
            })
        case .randomQuestion:
            randomQuestion(compitionClosure: { [weak self] (question) in
                self?.question = question
                compitionClosure(question)
            })
            break
        }
    }
    
    private func randomQuestion(compitionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        serverManager.categories { [weak self] (_, categories) in
            
            guard
                let fetchedCategories = categories,
                let strongSelf = self,
                fetchedCategories.count > 0
                else {
                    compitionClosure(nil)
                    return
            }
            
            let randomCategoryIndex = Int(arc4random() % UInt32(fetchedCategories.count))
            
            strongSelf.randomQuestion(fromCategoryID: fetchedCategories[randomCategoryIndex].categoryID, compitionClosure: { (question) in
                compitionClosure(question)
                return
            })
        }
    }
    
    private func randomQuestion(fromCategoryID categoryID: String, compitionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        
        serverManager.questions(fromCategoryID: categoryID, offset: 0, pageSize: 0) {(_, questions) in
            
            guard
                let fetchedQuestions = questions,
                fetchedQuestions.count > 0
                else {
                    compitionClosure(nil)
                    return
            }
            
            let randomQuestionIndex = Int(arc4random() % UInt32(fetchedQuestions.count))
            compitionClosure(fetchedQuestions[randomQuestionIndex])
        }
    }
    
    private func question(fromQuestionID questionID: String, compitionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        
        serverManager.categories { [weak self] (_, categories) in
            guard let fetchedCategories = categories else {
                compitionClosure(nil)
                return
            }
            
            guard let strongSelf = self else {
                compitionClosure(nil)
                return
            }
            
            strongSelf.searchQuestion(in: fetchedCategories, questionID: questionID, completionClosure: { (question) in
                compitionClosure(question)
            })
            
        }
    }
    
    private func searchQuestion(in categories: [QuizTestCategory], questionID: String, completionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        qestionWithRecursiveSearch(in: categories, questionID: questionID, offset: 0) { (question) in
            completionClosure(question)
        }
    }
    
    private func qestionWithRecursiveSearch(in categories: [QuizTestCategory], questionID: String, offset: Int, completionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        let categoriesCount = categories.count - 1
        
        if offset > categoriesCount {
            completionClosure(nil)
            return
        }
        
        let currentCategory = categories[offset]
        
        searchQuestion(in: currentCategory, questionID: questionID) { [weak self] (question) in
            
            if question != nil {
                completionClosure(question)
                return
            } else {
                self?.qestionWithRecursiveSearch(in: categories, questionID: questionID, offset: offset + 1, completionClosure: { (question) in
                    completionClosure(question)
                })
            }
        }
    }
    
    private func searchQuestion(in category: QuizTestCategory, questionID: String, completionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        questionWithRecursiveSearch(in: category, questionID: questionID, questionOffset: 0) { (question) in
            completionClosure(question)
        }
    }
    
    private func questionWithRecursiveSearch(in category: QuizTestCategory, questionID: String, questionOffset offset: Int, completionClosure: @escaping (_ question: QuizTestQuestion?) -> Void) {
        
        serverManager.questions(fromCategoryID: category.categoryID, offset: offset, pageSize: 1) { [weak self] (_, questions) in
            guard
                let fetchedQuestions = questions,
                let question = fetchedQuestions.first,
                let strongSelf = self
                else {
                    completionClosure(nil)
                    return
            }
            
            if question.questionID == questionID {
                completionClosure(question)
                return
            } else {
                strongSelf.questionWithRecursiveSearch(in: category, questionID: questionID, questionOffset: offset + 1, completionClosure: { (question) in
                    completionClosure(question)
                })
            }
        }
    }
    
    func isAnswerRight(userAnswer: String) -> Bool {
        guard let fetchedQuestion = question else {
            return false
        }
        
        let userAnswerID: Int? = {
            for (index, value) in fetchedQuestion.answers.enumerated() {
                if userAnswer == value {
                    return index
                }
            }
            
            return nil
        }()
        
        if let fetchedUserAnswerID = userAnswerID,
            fetchedUserAnswerID == fetchedQuestion.rightAnswer {
            return true
        }
    
        return false
    }
}
