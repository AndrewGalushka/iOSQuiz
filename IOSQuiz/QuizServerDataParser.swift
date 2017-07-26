//
//  QuizServerManagerDataParser.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation


struct QuizServerDataParser {
    
    func error(data: Data) -> String? {
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        
        guard let dictionaryFromData = jsonData as? [String: String] else {
            return nil
        }
        
        if let errorMessage = dictionaryFromData["error:"] {
            return errorMessage
        } else if let errorMessage = dictionaryFromData["error"] {
            return errorMessage
        } else {
            return nil
        }
    }
    
    func token(data: Data) -> String? {
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let tokenDictionaryFromData = jsonData as? [String: String] else {
            return nil
        }
        
        guard let token = tokenDictionaryFromData["token"] else {
            return nil
        }
        
        return token
    }
    
    func categories(data: Data) -> [QuizTestCategory]? {
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let categories = jsonData as? [[String: String]] else {
            return nil
        }
        
        var quizTestCategories = [QuizTestCategory]()
        
        for category in categories {
            guard let categoryName = category["categoryName"] else {fatalError("ERROR: no 'categoryName' key in category")}
            guard let categoryID = category["objectId"] else { fatalError("ERROR: no 'objectId' key in category") }
            
            quizTestCategories.append(QuizTestCategory(categoryName: categoryName, categoryID: categoryID))
        }
        
        return quizTestCategories
    }
    
    func questions(data: Data) -> [QuizTestQuestion]? {
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        var fetchedQuestions = [QuizTestQuestion]()
        
        guard let questions = jsonData as? [[String: Any]] else {
            return nil
        }
        
        for question in questions {
            guard
                let answers = question["answers"] as? [String],
                let questionText = question["question"] as? String,
                let rightAnswer = question["rightAnswer"] as? String,
                let categoryID = question["categoryId"] as? String,
                let questionID = question["objectId"] as? String
                else {
                    return nil
            }
            
            
            guard let rightAnswerIntValue = Int(rightAnswer) else {fatalError()}
            
            let fetchedQuestion = QuizTestQuestion(questionText: questionText,
                                                   answers: answers,
                                                   rightAnswer: rightAnswerIntValue,
                                                   categoryID: categoryID,
                                                   questionID: questionID)
            
            fetchedQuestions.append(fetchedQuestion)
        }
        
        return fetchedQuestions
    }
    
    func history(data: Data) -> [QuizTestHistory] {
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let historyResults = jsonData as? [[String: Any]] else {
            return []
        }
        
        let history = historyResults.map( { (historyResult) -> QuizTestHistory? in
            guard let date = historyResult["date"] as? Int else {return nil}
            guard let categoryName = historyResult["name"] as? String else {return nil}
            
            guard let resultsDictionary = historyResult["result"] as? [[String: Any]] else {return nil}
            
            let results = resultsDictionary.map({ (result) -> QuizTestHistoryResult? in
                
                guard
                    let userAnswer = result["userAnswer"] as? String,
                    let answers = result["answers"] as? [String],
                    let rightAnswer = result["rightAnswer"] as? String,
                    let question = result["question"] as? String
                    else {
                        return nil
                }
                
                guard
                    let userAnswerInt = Int(userAnswer),
                    let rightAnswerInt = Int(rightAnswer)
                    else {
                        return nil
                }
            
                
                return QuizTestHistoryResult(userAnswer: userAnswerInt,
                                             answers: answers,
                                             rightAnswer: rightAnswerInt,
                                             question: question)
            }).flatMap{$0}
            
            return QuizTestHistory(date: date, categoryName: categoryName, quizTestResults: results)
        }).flatMap{$0}
     
        return history
    }
}


