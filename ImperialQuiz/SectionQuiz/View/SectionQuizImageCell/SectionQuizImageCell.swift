//
//  SectionQuizImageCell.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 09/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionQuizImageCell: UICollectionViewCell {
    
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
}

extension SectionQuizImageCell {
    
    func loadCounter(correct: Int, wrong: Int, current: Int, total: Int) {
        let correctString = NSMutableAttributedString(string: "\(correct)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGreen])
        let wrongString = NSAttributedString(string: "\(wrong)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        correctString.append(NSAttributedString(string: " / "))
        correctString.append(wrongString)
        correctString.append(NSAttributedString(string: " / \(current) / \(total)"))
        countLabel.attributedText = correctString
    }
    
}
