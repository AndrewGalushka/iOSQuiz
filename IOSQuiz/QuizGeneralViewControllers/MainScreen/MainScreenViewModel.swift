//
//  MainScreenViewModel.swift
//  IOSQuiz
//
//  Created by galushka on 7/3/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

class MainScreenViewModel {
    typealias StartingTestData = (testMode: QuizTestMode, testCategory: QuizTestCategory)
    
    private let quizAuthModule = QuizAuthModule()
    private let serverManager = QuizServerManager()
    
    var categories = [QuizTestCategory]()
    var quizPickerTableViewCellSettings: [QuizPickerTableViewCellSettings] {
        return categories.map {
            QuizPickerTableViewCellSettings.test(testCellSettings:
                QuizPickerTableViewBaseCellSettings(labelText: $0.categoryName, uniqueID: $0.categoryID))
        }
    }
    var title: String {
        return "Categories"
    }
    
    func isUserLogIn(completionClosure : @escaping (_ isUserLogIn: Bool) -> Void) {
        quizAuthModule.isUserTokenValid { (result) in
            completionClosure(result)
        }
    }

    func startingDataForChallengeMode() -> StartingTestData? {
        guard !categories.isEmpty else { return nil }
        
        let randomCategoryIndex = Int(arc4random() % UInt32(categories.count))
        let randTestCategory = categories[randomCategoryIndex]
        let startingTestData = StartingTestData(.challenge, randTestCategory)
        
        return startingTestData
    }
    
    func category(fromCategoryID categoryID: String) -> QuizTestCategory? {
        
        for category in self.categories {
            if categoryID == category.categoryID {
                return category
            }
        }
        
        return nil
    }
    
    func fetchCategories(completionClosure completion: @escaping (_ result: FetchResult) -> Void) {
        
        serverManager.categories { [weak self] (response, categories) in
            
            guard let strongSelf = self else {
                completion(.bad)
                return
            }
            
            switch response {
            case .successful:
                guard let fetchedCategories = categories else {
                    completion(.bad)
                    return
                }
                
                strongSelf.categories = fetchedCategories
                completion(.success)
                return
            case .cantConnectToServer:
                completion(FetchResult.notConnected(type: .toServer))
                return
            case .notConnectedToInternet:
                completion(FetchResult.notConnected(type: .toInternet))
                return
            case .unknownError:
                completion(.bad)
                return
            default:
                completion(.bad)
                return
            }
        }
    }
    
    func logOut() {
        serverManager.logOut()
    }
    
    enum FetchResult {
        case success
        case bad
        case notConnected(type: NoConnection)
        
        enum NoConnection {
            case toServer, toInternet
        }
    }
}
