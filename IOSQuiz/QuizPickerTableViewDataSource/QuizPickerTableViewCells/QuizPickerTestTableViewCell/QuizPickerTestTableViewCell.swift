//
//  QuizPickerTestTableViewCell.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizPickerTestTableViewCell: QuizPickerTableViewCell {

    @IBOutlet weak var contentAnswerLabel: UILabel!
    
    var tapGesture: UITapGestureRecognizer?
    
    var isCellClickable = false {
        didSet {
            if isCellClickable == true {
                registerTapGesture()
            } else {
                unregisterTapGesture()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure(settings: QuizPickerTableViewCellSettings) {
        if case QuizPickerTableViewCellSettings.test(let baseSettings) = settings {
            self.contentAnswerLabel.text = baseSettings.labelText
            self.id = baseSettings.uniqueID
            isCellClickable = true
        }
        
        if case QuizPickerTableViewCellSettings.history(let historySettings) = settings {
            self.contentAnswerLabel.text = historySettings.labelText
            
            if let fetchedLabelAnswerMark = historySettings.labelAnswerMark {
                if fetchedLabelAnswerMark == .correctAnswer {
                    markLabelRightAnswer()
                } else {
                    markLabelWrongAnswer()
                }
            }

            isCellClickable = false
        }
    }
    
    override func cellDidClicked() {
        super.cellDidClicked()
        markLabelRightAnswer()
    }
    
    override func registerTapGesture() {
        if isCellClickable {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellDidClicked))
            
            if let unwrappedTapGesure = tapGesture {
                self.contentAnswerLabel.addGestureRecognizer(unwrappedTapGesure)
                self.contentAnswerLabel.isUserInteractionEnabled = true
            }
        }
    }
    
    func unregisterTapGesture() {

        if let unwrappedTapGesture = tapGesture {
            self.contentAnswerLabel.removeGestureRecognizer(unwrappedTapGesture)
        }
    }
    
    func markLabelRightAnswer() {
        contentAnswerLabel.layer.borderWidth = contentAnswerLabel.bounds.height * 0.1
        contentAnswerLabel.layer.borderColor = UIColor.yellow.cgColor
    }
    
    func markLabelWrongAnswer() {
        contentAnswerLabel.layer.borderWidth = contentAnswerLabel.bounds.height * 0.1
        contentAnswerLabel.layer.borderColor = UIColor.red.cgColor
    }
    
    override func unmarkLabel() {
        contentAnswerLabel.layer.borderWidth = 0.0
    }
}
