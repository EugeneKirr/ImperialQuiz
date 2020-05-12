//
//  SectionQuizOptionCell.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 09/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionQuizOptionCell: UICollectionViewCell {
    
    @IBOutlet weak var quizIndexLabel: UILabel!
    @IBOutlet weak var quizOptionLabel: UILabel!
    
    var isChosen = false {
        didSet {
            backgroundColor = isChosen ? .lightGray : .none
        }
    }
    
    var isValid: Bool? {
        didSet {
            guard let boolValue = isValid else { return }
            backgroundColor = boolValue ? .systemGreen : .systemRed
        }
    }
    
}

extension SectionQuizOptionCell {
    
    func loadView(_ index: Int, _ option: String) {
        quizIndexLabel.text = "\(index)."
        quizOptionLabel.text = option
    }
    
}
