//
//  QuizAuthTextField.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizAuthTextField: UITextField {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = self.frame.height / 2
    }
}
