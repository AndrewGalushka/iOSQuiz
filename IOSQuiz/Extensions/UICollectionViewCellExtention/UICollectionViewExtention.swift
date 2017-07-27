//
//  UICollectionViewExtention.swift
//  IOSQuiz
//
//  Created by galushka on 6/26/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.ID, for: indexPath) as? T else {
            preconditionFailure("Unable to dequeue \(T.description()) for indexPath: \(indexPath)")
        }
        
        return cell
    }
    
    func registerNib(cell: UICollectionViewCell.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.ID)
    }
}
