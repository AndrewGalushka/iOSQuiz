//
//  QuizAlerts.swift
//  IOSQuiz
//
//  Created by galushka on 6/15/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

struct QuizAlerts {
    
    typealias actionComplition = (_ action: UIAlertAction) -> Void
    
    func presentNotConnectedToInternet(on viewController: UIViewController, alertActionComplition complition: actionComplition?) {
        let title = "No inernet connection"
        let message = "Connect to internet and try again"
        
        presentInformAlert(on: viewController, title: title, message: message, alertActionComplition: complition)
    }
    
    func presentCantConnectToServer(on viewController: UIViewController, alertActionComplition complition: actionComplition?) {
        let title = "Cannot connect to the server"
        let message: String? = nil
        
        presentInformAlert(on: viewController, title: title, message: message, alertActionComplition: complition)
    }
    
    func presentTimeLeftAlert(on viewController: UIViewController, alertActionComplition complition: actionComplition?) {
        let title = "Time Left"
        let message = "Test Is Failed!"
        
        presentInformAlert(on: viewController, title: title, message: message, alertActionComplition: complition)
    }
    
    func presentWrongAnswerAlert(on viewController: UIViewController, alertActionComplition complition: actionComplition?) {
        let title = "Wrong Answer"
        let message = "Test Is Failed!"
        
        presentInformAlert(on: viewController, title: title, message: message, alertActionComplition: complition)
    }
    
    func presentTestIsFishedAlert(on viewController: UIViewController, alertActionComplition complition: actionComplition?) {
        let title = "Test is finished"
        let message = "View Your Result in History Screen"
        
        presentInformAlert(on: viewController, title: title, message: message, alertActionComplition: complition)
    }
    
    func presentInformAlert(on viewController: UIViewController,
                            title: String?,
                            message: String?,
                            alertActionComplition complition: actionComplition?) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: complition)
        
        alertController.addAction(actionOK)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
