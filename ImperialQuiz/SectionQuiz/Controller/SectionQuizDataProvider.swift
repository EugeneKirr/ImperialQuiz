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
    
    weak var delegate: UIInteractionDelegate?
    
    var sectionTitle = "" {
        didSet {
            quizManager.prepareQuizUnits(for: sectionTitle)
            (roundOptions, validOptionIndex) = quizManager.fetchNewRoundOptions(quizRound: currentRound, numberOfOptions: 4)
            roundImage = quizManager.fetchRoundImage(quizRound: currentRound)
        }
    }
    
    var totalRounds: Int {
        return quizManager.fetchQuizRoundsCount()
    }
    var currentRound = 0 {
        didSet {
            roundImage = nil
            guard currentRound < totalRounds else { return }
            (roundOptions, validOptionIndex) = quizManager.fetchNewRoundOptions(quizRound: currentRound, numberOfOptions: 4)
            roundImage = quizManager.fetchRoundImage(quizRound: currentRound)
        }
    }
    var correctCount = 0
    var wrongCount = 0
    
//    weak var roundImage: UIImage? {
//        return quizManager.fetchRoundImage(quizRound: currentRound)
//    }
    var roundOptions = [String]()
    weak var roundImage: UIImage? = nil
    
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
            return collectionView.dequeueReusableCell(SectionQuizImageCell.self, for: indexPath) { [weak self] cell in
                guard let self = self else { return }
                cell.quizImageView.image = self.roundImage
                cell.loadCounter(correct: self.correctCount, wrong: self.wrongCount, current: (self.currentRound + 1), total: self.totalRounds)
                guard !self.isConfirmTapped else { return }
                cell.startTimer(count: 20) { [weak collectionView] in
                    self.isConfirmTapped = true
                    collectionView?.reloadData()
                }
            }
        case .options:
            return collectionView.dequeueReusableCell(SectionQuizOptionCell.self, for: indexPath) { [roundOptions, chosenOptionIndex, isConfirmTapped, validOptionIndex] cell in
                cell.loadView((indexPath.row + 1), roundOptions[indexPath.row])
                cell.isChosen = (indexPath.row == chosenOptionIndex)
                if isConfirmTapped && cell.isChosen {
                    cell.isValid = (indexPath.row == validOptionIndex)
                }
            }
        case .confirm:
            return collectionView.dequeueReusableCell(SectionQuizActionCell.self, for: indexPath) { [currentRound, totalRounds, isConfirmTapped] cell in
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
            guard (chosenOptionIndex != nil) || (isConfirmTapped) else { return }
            isConfirmTapped = !isConfirmTapped
            guard currentRound == totalRounds else { collectionView.reloadData(); return }
            let sectionManager = SectionManager()
            let newSectionRating = 5 * correctCount / totalRounds
            sectionManager.updateSectionRating(with: newSectionRating, sectionTitle: sectionTitle) { [sectionTitle] in
                NotificationManager.shared.scheduleTopRatingLocalNotification(title: sectionTitle, rating: newSectionRating)
            }
            delegate?.showFinishAlert(newRating: newSectionRating)
            return
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
