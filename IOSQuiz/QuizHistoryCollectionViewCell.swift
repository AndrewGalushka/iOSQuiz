//
//  SpringCollectionViewCell.swift
//  QuizCollectionView
//
//  Created by galushka on 6/19/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

struct QuizHistoryCollectionViewCellSettings {
    let numberID: Int
    let cellType: QuizHistoryAnswerMark
}

enum QuizHistoryAnswerMark {
    case correctAnswer
    case wrongAnswer
}

class QuizHistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let dim = min(self.bounds.size.width, self.bounds.size.height);
        
        self.layer.cornerRadius = dim/20
    }
    
    func configure(settings: QuizHistoryCollectionViewCellSettings) {
        numberLabel.text = String(settings.numberID)
        setCellBackground(from: settings.cellType)
    }
    
    func setCellBackground(from cellType: QuizHistoryAnswerMark) {
        
        switch cellType {
        case .correctAnswer:
            self.contentView.backgroundColor = .green
        case .wrongAnswer:
            self.contentView.backgroundColor = .red
        }
    }
}
