//
//  SectionQuizDataProvider.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionQuizDataProvider: NSObject {
    
    private let quizManager = QuizUnitManager()
    
    weak var delegate: NavigationDelegate?
    
    var sectionTitle = "" {
        didSet {
            quizManager.prepareQuizUnits(for: sectionTitle)
            (roundOptions, validOptionIndex) = quizManager.fetchNewRoundOptions(quizRound: currentRound, numberOfOptions: 4)
        }
    }
    
    var totalRounds: Int {
        return quizManager.fetchQuizRoundsCount()
    }
    var currentRound = 0 {
        didSet {
            guard currentRound < totalRounds else { return }
            (roundOptions, validOptionIndex) = quizManager.fetchNewRoundOptions(quizRound: currentRound, numberOfOptions: 4)
        }
    }
    var correctCount = 0
    var wrongCount = 0
    
    var roundImage: UIImage {
        return quizManager.fetchRoundImage(quizRound: currentRound)
    }
    var roundOptions = [String]()
    
    var validOptionIndex: Int?
    var chosenOptionIndex: Int?

    var isConfirmTapped = false {
        didSet {
            guard !isConfirmTapped else {
                if (chosenOptionIndex == validOptionIndex) {
                    correctCount += 1
                } else {
                    wrongCount += 1
                }
                return
            }
            currentRound += 1
            chosenOptionIndex = nil
        }
    }
    
}

extension SectionQuizDataProvider: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return QuizSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let quizSection = QuizSections(section)
        switch quizSection {
        case .image: return 1
        case .options: return roundOptions.count
        case .confirm: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let quizSection = QuizSections(indexPath.section)
        switch quizSection {
        case .image:
            return configureReusableProjectCell(collectionView, indexPath, .sectionQuizImageCell) { (cell: SectionQuizImageCell) in
                cell.quizImageView.image = roundImage
                cell.loadCounter(correct: correctCount, wrong: wrongCount, current: (currentRound + 1), total: totalRounds)
            }
        case .options:
            return configureReusableProjectCell(collectionView, indexPath, .sectionQuizOptionCell) { (cell: SectionQuizOptionCell) in
                cell.loadView((indexPath.row + 1), roundOptions[indexPath.row])
                cell.isChosen = (indexPath.row == chosenOptionIndex)
                if isConfirmTapped && cell.isChosen {
                    cell.isValid = (indexPath.row == validOptionIndex)
                }
            }
        case .confirm:
            return configureReusableProjectCell(collectionView, indexPath, .sectionQuizActionCell) { (cell: SectionQuizActionCell) in
                let actionLabel = currentRound < (totalRounds - 1) ? "Next" : "Finish"
                cell.quizActionLabel.text = isConfirmTapped ? actionLabel : "Confirm"
            }
        }
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let quizSection = QuizSections(indexPath.section)
        switch quizSection {
        case .image: return
        case .options:
            guard !isConfirmTapped else { return }
            chosenOptionIndex = indexPath.row
            collectionView.reloadSections([QuizSections.options.rawValue])
        case .confirm:
            guard chosenOptionIndex != nil else { return }
            isConfirmTapped = !isConfirmTapped
            guard currentRound < totalRounds else {
                let sectionManager = SectionManager()
                let newSectionRating = 5 * correctCount / totalRounds
                sectionManager.updateSectionRating(with: newSectionRating, sectionTitle: sectionTitle)
                delegate?.popToRootVC()
                return
            }
            collectionView.reloadData()
        }
    }
    
}

extension SectionQuizDataProvider: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let quizSection = QuizSections(indexPath.section)
        switch quizSection {
        case .image: return CGSize(width: collectionView.bounds.width, height: 0.5 * collectionView.bounds.height)
        case .options: return CGSize(width: collectionView.bounds.width, height: 0.1 * collectionView.bounds.height)
        case .confirm: return CGSize(width: collectionView.bounds.width, height: 0.1 * collectionView.bounds.height)
        }
    }
    
}
