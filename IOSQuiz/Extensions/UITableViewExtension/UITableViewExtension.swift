//
//  UITableViewExtension.swift
//  IOSQuiz
//
//  Created by galushka on 6/26/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.ID, for: indexPath) as? T else {
            preconditionFailure("Unable to dequeue \(T.description()) for indexPath: \(indexPath)")
        }
        
        return cell
    }
    
    func registerNib(cell: UITableViewCell.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.ID)
    }

}
