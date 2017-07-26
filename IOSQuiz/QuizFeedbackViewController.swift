//
//  QuizFeedbackViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/30/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizFeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTextView.layer.cornerRadius = 10.0
        feedbackTextView.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isToolbarHidden = true
    }
    
    @IBAction func feedbackButtonPressed(_ sender: Any) {
        runActivityIndcator(timeInterval: 0.5) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func backgroundTapGesturePressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func runActivityIndcator(timeInterval: Double, complitionBlock: @escaping () -> Void) {
        let activitiIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activitiIndicator.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 24, height: 24)
        self.view.addSubview(activitiIndicator)
        
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                activitiIndicator.startAnimating()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: {
                activitiIndicator.stopAnimating()
                activitiIndicator.removeFromSuperview()
                complitionBlock()
            })
        }
    }
}

extension QuizFeedbackViewController {
    static var storyboardID: String {
        return "QuizFeedbackViewControllerStoryboardID"
    }
}
