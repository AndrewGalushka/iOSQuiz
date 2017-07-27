//
//  UICollectionViewNibExtention.swift
//  QuizCollectionView
//
//  Created by galushka on 6/19/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static var ID: String {
        return String(describing: self)
    }
}
