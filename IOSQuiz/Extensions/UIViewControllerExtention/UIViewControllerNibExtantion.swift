//
//  UIViewControllerNibExtantion.swift
//  IOSQuiz
//
//  Created by galushka on 6/9/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func bundle() -> Bundle {
        return Bundle(for: self)
    }
}
