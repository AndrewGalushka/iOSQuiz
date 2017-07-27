//
//  QuizPickerTableViewCell.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

class QuizPickerTableViewCell: UITableViewCell, QuizPickerTableViewCellType, QuizPickerTestTableViewCellUnmarkDelegate {

    @IBOutlet weak var contentLabel: UILabel!

    var id: String?
    weak var delegate: QuizPickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(settings: QuizPickerTableViewCellSettings) {
        
        if case QuizPickerTableViewCellSettings.test(let baseSettings) = settings {
            contentLabel.text = baseSettings.labelText
            self.id = baseSettings.uniqueID
        }
    }
    
    @objc func cellDidClicked() {
        print("cell \(id ?? "") clicked")
        
        if let cellID = id {
            delegate?.cellDidClicked(cellID: cellID)
        }
    }
    
    func registerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellDidClicked))
        self.addGestureRecognizer(tapGesture)
    }
    
    func unmarkLabel() {
        contentLabel.layer.borderWidth = 0.0
    }
}
