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
    @IBOutlet weak var timerLabel: UILabel!
    
    weak var timer: Timer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
    }
    
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

extension SectionQuizImageCell {
    
    func startTimer(count: Int, completion: @escaping () -> Void) {
        var timerCount = count
        timerLabel.text = ":\(timerCount)"
        print(timerCount)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            timerCount -= 1
            guard timerCount != 0 else {
                self?.timerLabel.text = "Time is over"
                timer.invalidate()
                completion()
                return
            }
            self?.timerLabel.text = ":\(timerCount)"
            print(timerCount)
        }
    }
    
}
