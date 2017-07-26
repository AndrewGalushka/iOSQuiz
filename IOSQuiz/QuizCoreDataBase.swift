//
//  QuizSQLiteDataBase.swift
//  IOSQuiz
//
//  Created by galushka on 6/12/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol QuizCoreDataBaseType {
    func addHistory(_ quizTestHistory: QuizTestHistory)
}

class QuizCoreDataBase: QuizCoreDataBaseType {
    
    let quizCoreDataBaseName = "QuizCoreDataBase"
    
    let quizTestHistoryEntityName = "QuizTestHistoryCoreData"
    
    let quizTestHistoryCoreDataCategoryNameKey = "categoryName"
    let quizTestHistoryCoreDataDateKey = "date"
    let quizTestHistoryCoreDataResultKey = "result"
    
    func addHistory(_ quizTestHistory: QuizTestHistory) {

        let managedContext = self.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: quizTestHistoryEntityName,
                                                      in: managedContext) else {
                                                        fatalError("")
        }
        
        let history = NSManagedObject.init(entity: entity, insertInto: managedContext)
        
        var resultsCoreData = [QuizTestHistoryResultCoreData]()
        
        for result in quizTestHistory.results {
            let coreDataResult = QuizTestHistoryResultCoreData(quizTestHistoryResult: result)
            
            resultsCoreData.append(coreDataResult)
        }
        
        history.setValue(quizTestHistory.categoryName, forKey: quizTestHistoryCoreDataCategoryNameKey)
        history.setValue(quizTestHistory.date, forKey: quizTestHistoryCoreDataDateKey)
        history.setValue(resultsCoreData, forKey: quizTestHistoryCoreDataResultKey)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    func addCategory(_ quizTestCategory: QuizTestCategory) {
//        
//        let managedContext = self.persistentContainer.viewContext
//        
//        let predicate = NSPredicate(format: "categoryID = %@ AND categoryName = %@", quizTestCategory.categoryID, quizTestCategory.categoryName)
//        
//        let managedObjectCategory = QuizTestCategoryCoreData(context: managedContext)
//        managedObjectCategory.categoryID = quizTestCategory.categoryID
//        managedObjectCategory.categoryName = quizTestCategory.categoryName
//    }
    
//    func isCategoryAlreadyExists(_ quizTestCategory: QuizTestCategory) -> false {
//        let managedContextContext = self.persistentContainer.viewContext
//        
//        let predicate = NSPredicate(format: "categoryID = %@ AND categoryName = %@", quizTestCategory.categoryID, quizTestCategory.categoryName)
//        let request = NSFetchRequest<NSManagedObject>(entityName: "QuizTestHistoryResultCoreData")
//        request.predicate = predicate
//        
//        do {
//            let searchedCategories = try managedContextContext.fetch(request)
//            
//            if searchedCategories.count > 0 {
//                return false
//            }
//            
//        } catch(let error) {
//            
//            let error = error as NSError
//            print("\(error.description) \(error.userInfo)")
//            
//            return false
//        }
//    }
//    
    func getCategories() -> [QuizTestCategory] {
        
        do {
            guard let fetchedCategoryes = try persistentContainer.viewContext.fetch(QuizTestCategoryCoreData.fetchRequest()) as? [QuizTestCategoryCoreData] else {
                return []
            }
            
            let categories = fetchedCategoryes.map { (fetchedCategory) -> QuizTestCategory? in
                
                guard let categoryName = fetchedCategory.categoryName else { return nil }
                guard let categoryID = fetchedCategory.categoryID else { return nil }
                
                return QuizTestCategory(categoryName: categoryName,
                                        categoryID: categoryID)
                }.flatMap{$0}
            
            return categories
        } catch {
            print("cant get categories")
            return []
        }
    }
    
    func getHistories() -> [QuizTestHistory] {
        
        let managedContext = self.persistentContainer.viewContext
        
        let fetchedRequest = NSFetchRequest<NSManagedObject>(entityName: quizTestHistoryEntityName)
        
        do {
            let historiesCoreDataResults = try managedContext.fetch(fetchedRequest)
            
            var histories = [QuizTestHistory]()
            
            for historyCoreDataResult in historiesCoreDataResults {
                guard
                    let date = historyCoreDataResult.value(forKey: quizTestHistoryCoreDataDateKey) as? Int,
                    let categoryName = historyCoreDataResult.value(forKey: quizTestHistoryCoreDataCategoryNameKey) as? String,
                    let quizTestHistoryResultsCoreData = historyCoreDataResult.value(forKey: quizTestHistoryCoreDataResultKey) as? [QuizTestHistoryResultCoreData]
                    else {
                        fatalError("")
                }
                
                var historyResults = [QuizTestHistoryResult]()
                
                for history in  quizTestHistoryResultsCoreData{
                    historyResults.append(history.quizTestHistoryResult())
                }
                
                let history = QuizTestHistory(date: date, categoryName: categoryName, quizTestResults: historyResults)
                histories.append(history)
            }
            
            return histories
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "QuizCoreDataBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
