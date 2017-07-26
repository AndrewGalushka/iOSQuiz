//
//  QuizHistoryTableViewCell.swift
//  IOSQuiz
//
//  Created by galushka on 6/20/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

extension QuizHistoryTableViewCell {
    func configure(settings: QuizHistoryTableViewCellSettings) {
        self.testNameLabel.text = settings.testName
        self.testDateLabel.text = settings.date
        self.amPmFormatLabel.text = settings.amPmFormat  
    }
}

class QuizHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var testNameLabel: UILabel!
    @IBOutlet weak var testDateLabel: UILabel!
    @IBOutlet weak var amPmFormatLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
