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
            lastRound = quizManager.prepareQuizUnits(for: sectionTitle)
            (roundOptions, validOptionIndex) = quizManager.fetchNewRoundOptions(quizRound: quizRound)
        }
    }
    
    var lastRound = 0
    
    var quizRound = 0 {
        didSet {
            guard quizRound < (lastRound) else { return }
            (roundOptions, validOptionIndex) = quizManager.fetchNewRoundOptions(quizRound: quizRound)
        }
    }
    
    var roundImage: UIImage {
        return quizManager.fetchRoundImage(quizRound: quizRound)
    }

    var roundOptions = [String]()
    
    var validOptionIndex: Int?
    
    var chosenOptionIndex: Int?

    var isConfirmTapped = false
    
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
        case .options: return 4
        case .confirm: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let quizSection = QuizSections(indexPath.section)
        switch quizSection {
        case .image:
            return configureReusableProjectCell(collectionView, indexPath, .sectionQuizImageCell) { (cell: SectionQuizImageCell) in
                cell.quizImageView.image = roundImage
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
                let actionLabel = quizRound < (lastRound - 1) ? "Next" : "Finish"
                cell.quizActionLabel.text = isConfirmTapped ? actionLabel : "Confirm"
            }
        }
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let quizSection = QuizSections(rawValue: indexPath.section) else { return }
        switch quizSection {
        case .image: return
        case .options:
            guard !isConfirmTapped else { return }
            chosenOptionIndex = indexPath.row
            collectionView.reloadSections([QuizSections.options.rawValue])
        case .confirm:
            guard chosenOptionIndex != nil else { return }
            isConfirmTapped = !isConfirmTapped
            if !isConfirmTapped {
                quizRound += 1
                chosenOptionIndex = nil
            }
            guard quizRound < (lastRound) else { delegate?.popToRootVC(); return }
            collectionView.reloadData()
        }
    }
    
}

extension SectionQuizDataProvider: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let quizSection = QuizSections(rawValue: indexPath.section) else { return CGSize(width: 1, height: 1) }
        switch quizSection {
        case .image: return CGSize(width: collectionView.bounds.width, height: 0.5 * collectionView.bounds.height)
        case .options: return CGSize(width: collectionView.bounds.width, height: 0.1 * collectionView.bounds.height)
        case .confirm: return CGSize(width: collectionView.bounds.width, height: 0.1 * collectionView.bounds.height)
        }
    }
    
}
