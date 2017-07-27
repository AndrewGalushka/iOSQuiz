//
//  RoundedUIButton.swift
//  IOSQuiz
//
//  Created by galushka on 6/16/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class RoundedUIButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

}
