//
//  UIColorRandom.swift
//  IOSQuiz
//
//  Created by galushka on 6/7/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat(arc4random() % 255) / 255.0
        let green = CGFloat(arc4random() % 255) / 255.0
        let blue = CGFloat(arc4random() % 255) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
