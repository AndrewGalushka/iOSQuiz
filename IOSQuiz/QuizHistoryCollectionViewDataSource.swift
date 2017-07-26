//
//  QuizHistoryCollectionViewDataSource.swift
//  QuizCollectionView
//
//  Created by galushka on 6/19/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit


class QuizHistoryCollectionViewDataSource: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var cellCount: Int
    var cellsSettings = [QuizHistoryCollectionViewCellSettings]()
    weak var delegate: QuizHistoryCollectionViewDelegate?
    
    init(collectionView: UICollectionView, cellsSettings: [QuizHistoryCollectionViewCellSettings]) {
        
        self.cellCount = cellsSettings.count
        self.cellsSettings = cellsSettings
        
        super.init()
        
        collectionView.register(QuizHistoryCollectionViewCell.nib, forCellWithReuseIdentifier: QuizHistoryCollectionViewCell.ID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: QuizHistoryCollectionViewCell = collectionView.dequeueCell(forIndexPath: indexPath)
        
        cell.configure(settings: cellsSettings[indexPath.row])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width * 0.45 , height: collectionView.bounds.width * 0.35)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.bounds.height * 0.01, left: collectionView.bounds.width * 0.03, bottom: collectionView.bounds.height * 0.01, right: collectionView.bounds.width * 0.03)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemDidSelected(at: indexPath)
    }
}
